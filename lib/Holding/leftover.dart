//  is the main builder, but was replaced for a custom bottom navbar
//@override
//Widget build(BuildContext context) {
//  return Scaffold(
//    backgroundColor: Colors.transparent,
//    body: FutureBuilder<bool>(
//      future: authService.initUserData(),
//      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
//        return Container(
//          child: StreamBuilder(
//              stream: authService.user,
//              builder: (context, snapshot) {
//                if (snapshot.hasData) {
//                  return Stack(
//                    children: <Widget>[
//                      tabBody,
//                      bottomBar(),
//                    ],
//                  );
//                } else {
//                  return Container(
//                    child: Center(
//                      child: MaterialButton(
//                        onPressed: () => authService.googleSignIn(),
//                        color: Colors.white,
//                        textColor: Colors.black,
//                        child: Text('Login with Google'),
//                      ),
//                    ),
//                  );
//                }
//              }),
//        );
//      },
//    ),
//  );
//}

//Was the bottom navbar for before replacement
//Widget bottomBar() {
//  return Column(
//    children: <Widget>[
//      const Expanded(
//        child: SizedBox(),
//      ),
//      BottomBarView(
//        tabIconsList: tabIconsList,
//        addClick: () {
//          scanQR().then((value) {
//            _showDialog();
//          });
//        },
//        changeIndex: (int index) {
//          if (index == 0) {
//            animationController.reverse().then<dynamic>((data) {
//              if (!mounted) {
//                return;
//              }
//              setState(() {
//                tabBody =
//                    GroupScreen(animationController: animationController);
//              });
//            });
//          } else if (index == 1) {
//            animationController.reverse().then<dynamic>((data) {
//              if (!mounted) {
//                return;
//              }
//              setState(() {
//                tabBody =
//                    MyDiaryScreen(animationController: animationController);
//              });
//            });
//          } else if (index == 2) {
//            animationController.reverse().then<dynamic>((data) {
//              if (!mounted) {
//                return;
//              }
//              setState(() {
//                tabBody =
//                    MyDiaryScreen(animationController: animationController);
//              });
//            });
//          } else if (index == 3) {
//            animationController.reverse().then<dynamic>((data) {
//              if (!mounted) {
//                return;
//              }
//              setState(() {
//                tabBody =
//                    ProfileScreen(animationController: animationController);
//              });
//            });
//          }
//        },
//      ),
//    ],
//  );
//}

//Goes in the initState for the main screen for the old navbar
//tabIconsList.forEach((TabIconData tab) {
//tab.isSelected = false;
//});
//tabIconsList[0].isSelected = true;
//
//tabBody = GroupScreen(animationController: animationController);
