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

//Create Group Old Structure
//Future<String> createGroup(
//    String name, String country, String state, String city) async {
//  final FirebaseUser currentUser = await _auth.currentUser();
//
//  String _documentID;
//
//  CollectionReference refUserGroupsJoined = _db
//      .collection('users')
//      .document(currentUser.uid)
//      .collection('groupsJoined');
//
//  CollectionReference refGroups = _db.collection('groups');
//  DocumentReference refCurUser =
//  _db.collection('users').document(currentUserUID);
//
//  refGroups.add({
//    'name': name,
//    'country': country,
//    'state': state,
//    'city': city,
//    'memberCount': FieldValue.increment(1),
//    'eventCount': 0,
//  }).then((value) {
//    _documentID = value.documentID;
//    refGroups
//        .document(_documentID)
//        .setData({'gid': _documentID}, merge: true);
//  }).then((value) {
//    refGroups
//        .document(_documentID)
//        .collection('occupants')
//        .document(currentUser.uid)
//        .setData({
//      'name': currentUser.displayName,
//      'uid': currentUser.uid,
//      'status': 'owner',
//      'email': currentUser.email,
//    }, merge: true);
//  }).then((value) {
//    refUserGroupsJoined.document(_documentID).setData({
//      'name': name,
//      'country': country,
//      'state': state,
//      'city': city,
//      'gid': _documentID,
//      'status': 'owner',
//    }, merge: true);
//  });
//  return _documentID;
//}

//Card(
//child: InkWell(
//onTap: () {
//showDatePicker(
//context: context,
//initialDate: DateTime.now(),
//firstDate: DateTime(2001),
//lastDate: DateTime(9999),
//).then((date) {
//setState(() {
//selectedDate = date;
//});
//}).then((value) {
//showTimePicker(
//context: context, initialTime: TimeOfDay.now())
//    .then((time) {
//setState(() {
//selectedTime = time;
//});
//});
//});
//},
//child: ListTile(
//leading: Icon(
//Icons.stop,
//color: Colors.grey,
//),
//title: Text(endTime),
//),
//),
//),
