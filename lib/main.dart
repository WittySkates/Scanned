import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'auth.dart';
import 'profile/profile_screen.dart';
import 'app_theme.dart';
import 'my_diary/my_diary_screen.dart';
import 'groups/groups_screen.dart';
import 'dart:developer';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'bottom_navigation_view/bottom_bar.dart';

void main() {
  runApp(new MaterialApp(home: FitnessAppHomeScreen()));
}

class FitnessAppHomeScreen extends StatefulWidget {
  @override
  _FitnessAppHomeScreenState createState() => _FitnessAppHomeScreenState();
}

class _FitnessAppHomeScreenState extends State<FitnessAppHomeScreen>
    with TickerProviderStateMixin {
  AnimationController animationController;

  Widget tabBody = Container(
    color: AppTheme.background,
  );

  String resultQR;
  PersistentTabController _controller;

  List<Widget> _buildScreens() {
    return [
      GroupScreen(animationController: animationController),
      MyDiaryScreen(animationController: animationController),
      ProfileScreen(animationController: animationController),
      ProfileScreen(animationController: animationController),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.group),
        title: ("Groups"),
        activeColor: Colors.indigoAccent,
        inactiveColor: Colors.grey,
        isTranslucent: false,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.event),
        title: ("Calendar"),
        activeColor: Colors.indigoAccent,
        inactiveColor: Colors.grey,
        isTranslucent: false,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.assessment),
        title: ("Activity"),
        activeColor: Colors.indigoAccent,
        inactiveColor: Colors.grey,
        isTranslucent: false,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.account_circle),
        title: ("Profile"),
        activeColor: Colors.indigoAccent,
        inactiveColor: Colors.grey,
        isTranslucent: false,
      ),
    ];
  }

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);

    _controller = PersistentTabController(initialIndex: 0);
    resultQR = 'TESTING';
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return FutureBuilder(
        future: authService.initUserData(),
        builder: (context, snapshot) {
          return StreamBuilder(
              stream: authService.user,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return PersistentTabView(
                      controller: _controller,
                      screens: _buildScreens(),
                      items: _navBarsItems(),
                      confineInSafeArea: true,
                      navBarCurve: NavBarCurve.upperCorners,
                      backgroundColor: Colors.white,
                      handleAndroidBackButtonPress: true,
                      onItemSelected: (index) {
                        setState(() {});
                      },
                      customWidget: CustomNavBarWidget(
                        items: _navBarsItems(),
                        onItemSelected: (index) {
                          animationController.reverse().then<dynamic>((data) {
                            if (!mounted) {
                              return;
                            }
                            setState(() {
                              _controller.index = index;
                            });
                          });
                        },
                        selectedIndex: _controller.index,
                        onButtonTap: () {
                          scanQR().then((value) {
                            _showDialog();
                          });
                        },
                      ),
                      itemCount: 4,
                      navBarStyle: NavBarStyle.custom);
                } else {
                  return Container(
                    child: Center(
                      child: MaterialButton(
                        onPressed: () => authService.googleSignIn(),
                        color: Colors.white,
                        textColor: Colors.black,
                        child: Text('Login with Google'),
                      ),
                    ),
                  );
                }
              });
        });
  }

  Future scanQR() async {
    try {
      var scanData = await BarcodeScanner.scan();
      String res = await authService.scannedQR(scanData.rawContent);

      if (scanData.type.toString() == 'Cancelled') {
        setState(() {
          resultQR = 'cancelled';
        });
      } else if (res == 'joinedGroup') {
        setState(() {
          resultQR = 'You Joined the Group Successfully';
        });
      } else if (res == 'signedEvent') {
        setState(() {
          resultQR = 'You Signed Into the Event Successfully';
        });
      } else if (res == 'alreadyJoinedGroup') {
        setState(() {
          resultQR = 'You Already Joined this Group';
        });
      } else if (res == 'alreadySignedEvent') {
        setState(() {
          resultQR = 'You Already Signed Into this Event';
        });
      } else if (res == 'joinedEvent') {
        setState(() {
          resultQR = 'You Joined the Group and Signed Into the Event';
        });
      } else if (res == 'notTime') {
        setState(() {
          resultQR = 'The Window to Sign In is Currently Closed';
        });
      } else {
        setState(() {
          resultQR = 'This is not a recognized QR';
        });
      }
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        setState(() {
          resultQR = 'Camera Permission Denied';
        });
      } else {
        setState(() {
          resultQR = 'Something Went Wrong: $e';
        });
      }
    } on FormatException catch (e) {
      setState(() {
        resultQR = 'You pressed the back button before scanning';
      });
    } catch (e) {
      setState(() {
        resultQR = 'Something Went Wrong: $e';
      });
    }
  }

  void _showDialog() {
    if (resultQR != 'cancelled') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(
              resultQR,
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}
