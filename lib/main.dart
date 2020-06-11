import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'auth.dart';

import 'models/tabIcon_data.dart';
import 'traning/training_screen.dart';
import 'package:flutter/material.dart';
import 'bottom_navigation_view/bottom_bar_view.dart';
import 'fintness_app_theme.dart';
import 'my_diary/my_diary_screen.dart';

void main() {
  runApp(FitnessAppHomeScreen());
}

class FitnessAppHomeScreen extends StatefulWidget {
  @override
  _FitnessAppHomeScreenState createState() => _FitnessAppHomeScreenState();
}

class _FitnessAppHomeScreenState extends State<FitnessAppHomeScreen>
    with TickerProviderStateMixin {
  AnimationController animationController;

//  List<TabIconData> tabIconsList = TabIconData.tabIconsList;
  Widget tabBody = Container(
    color: FintnessAppTheme.background,
  );

  @override
  void initState() {
//    tabIconsListNew.forEach((TabIconData tab) {
//      tab.isSelected = false;
//    });
//    tabIconsListNew[0].isSelected = true;

    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    tabBody = MyDiaryScreen(animationController: animationController);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Scanned',
        home: Container(
          color: FintnessAppTheme.background,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: FutureBuilder<bool>(
              future: getData(),
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox();
                } else {
                  return Container(
                    child: StreamBuilder(
                        stream: authService.user,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Stack(
                              children: <Widget>[tabBody, bottomBar()],
                            );
                          } else {
                            return MaterialButton(
                              onPressed: () => authService.googleSignIn(),
                              color: Colors.white,
                              textColor: Colors.black,
                              child: Text('Login with Google'),
                            );
                          }
                        }),
                  );
                }
              },
            ),
          ),
        ));
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  Widget bottomBar() {
    return Column(
      children: <Widget>[
        const Expanded(
          child: SizedBox(),
        ),
        BottomBarView(
          tabIconsList: tabIconsList,
          addClick: () => authService.createGroup(
              'NHS', 'United States', 'Florida', 'Oldsmar'),
          changeIndex: (int index) {
            if (index == 0 || index == 2) {
              animationController.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody =
                      MyDiaryScreen(animationController: animationController);
                });
              });
            } else if (index == 1 || index == 3) {
              animationController.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody =
                      TrainingScreen(animationController: animationController);
                });
              });
            }
          },
        ),
      ],
    );
  }
}

//class MyApp extends StatefulWidget {
//  @override
//  _MyAppState createState() => _MyAppState();
//}
//
//class _MyAppState extends State<MyApp> {
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//        title: 'FlutterBase',
//        home: Scaffold(
//          appBar: AppBar(
//            title: Text('Flutterbase'),
//            backgroundColor: Colors.amber,
//          ),
//          body: Center(
//            child: Column(
//              mainAxisAlignment: MainAxisAlignment.center,
//              children: <Widget>[
//                LoginButton(),
//                UserProfile(),
//              ],
//            ),
//          ),
//          bottomNavigationBar: BottomAppBar(
//            shape: const CircularNotchedRectangle(),
//            child: Container(
//              height: 50.0,
//            ),
//          ),
//          floatingActionButton: FloatingActionButton(
//            onPressed: () => authService.createGroup(
//                'NHS', 'UnitedStates', 'Florida', 'Oldsmar'),
//            tooltip: 'Create New Group',
//            child: Icon(Icons.add),
//          ),
//          floatingActionButtonLocation:
//              FloatingActionButtonLocation.centerDocked,
//        ));
//  }
//}
//
//class UserProfile extends StatefulWidget {
//  @override
//  UserProfileState createState() => UserProfileState();
//}
//
//class UserProfileState extends State<UserProfile> {
//  Map<String, dynamic> _profile;
//  bool _loading = false;
//
//  @override
//  initState() {
//    super.initState();
//
//    // Subscriptions are created here
//    authService.profile.listen((state) => setState(() => _profile = state));
//
//    authService.loading.listen((state) => setState(() => _loading = state));
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Column(children: <Widget>[
//      Container(padding: EdgeInsets.all(20), child: Text(_profile.toString())),
//      Text(_loading.toString()),
//    ]);
//  }
//}
//
//class LoginButton extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return StreamBuilder(
//        stream: authService.user,
//        builder: (context, snapshot) {
//          if (snapshot.hasData) {
//            return Column(
//              children: <Widget>[
//                MaterialButton(
//                  onPressed: () => authService.signOut(),
//                  color: Colors.white,
//                  textColor: Colors.black,
//                  child: Text('Signout'),
//                ),
//                MaterialButton(
//                  onPressed: () => authService.createGroup(
//                      'NHS', 'US', 'Florida', 'Clearwater'),
//                  color: Colors.green,
//                  textColor: Colors.white,
//                  child: Text('Create new group'),
//                ),
//                QrImage(
//                  data: '1234567',
//                  version: QrVersions.auto,
//                  size: 200,
//                )
//              ],
//            );
//          } else {
//            return MaterialButton(
//              onPressed: () => authService.googleSignIn(),
//              color: Colors.white,
//              textColor: Colors.black,
//              child: Text('Login with Google'),
//            );
//          }
//        });
//  }
//}

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
