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

//Activity Screen
//import 'package:flutter/material.dart';
//import '../app_theme.dart';
//import '../auth.dart';
//
//class ActivityScreen extends StatefulWidget {
//  const ActivityScreen({Key key, this.animationController}) : super(key: key);
//  final AnimationController animationController;
//  @override
//  _ActivityScreen createState() => _ActivityScreen();
//}
//
//class _ActivityScreen extends State<ActivityScreen> {
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      backgroundColor: AppTheme.background,
//      appBar: AppBar(
//        title: Text('Activity'),
//        backgroundColor: Colors.indigoAccent,
//      ),
//      body: StreamBuilder(
//          stream: authService.getUserActivity(),
//          builder: (context, snapshot) {
//            if (!snapshot.hasData) {
//              return Center(
//                child: CircularProgressIndicator(),
//              );
//            } else {
//              return ListView.builder(
//                padding: EdgeInsets.only(
//                  top: 16,
//                ),
//                itemCount: snapshot.data.documents.length,
//                scrollDirection: Axis.vertical,
//                itemBuilder: (context, index) {
//                  return Card(
//                    shape: RoundedRectangleBorder(
//                      borderRadius: BorderRadius.circular(10.0),
//                    ),
//                    child: ListTile(
//                      title: Text(
//                        snapshot.data.documents[index].data['message'],
//                        style: TextStyle(
//                            fontFamily: AppTheme.fontName,
//                            fontWeight: FontWeight.w700,
//                            letterSpacing: 1.2,
//                            color: AppTheme.darkerText),
//                      ),
//                    ),
//                  );
//                },
//              );
//            }
//          }),
//    );
//  }
//}

// Event Screen
//import 'package:flutter/material.dart';
//import 'package:scanned/groups/event_details_screen.dart';
//import 'package:scanned/groups/add_event_screen.dart';
//import 'package:intl/intl.dart';
//import '../app_theme.dart';
//import '../auth.dart';
//
//class EventsScreen extends StatefulWidget {
//  const EventsScreen({Key key, this.animationController, this.gid})
//      : super(key: key);
//  final AnimationController animationController;
//  final String gid;
//  @override
//  _EventsScreen createState() => _EventsScreen();
//}
//
//class _EventsScreen extends State<EventsScreen> {
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      backgroundColor: AppTheme.background,
//      appBar: getAppBarUI(),
//      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
//          Widget>[
////        Padding(
////          padding: const EdgeInsets.fromLTRB(10, 20, 0, 10),
////          child: Text(
////            'Upcoming Events',
////            style: TextStyle(
////                fontSize: 20,
////                fontFamily: AppTheme.fontName,
////                fontWeight: FontWeight.w700,
////                letterSpacing: 1.2,
////                color: AppTheme.darkerText),
////          ),
////        ),
//        StreamBuilder(
//            stream: authService.getGroupEventsUpcoming(widget.gid),
//            builder: (context, snapshot) {
//              if (!snapshot.hasData) {
//                return Container();
//              }
//              return Expanded(
//                child: ListView.builder(
//                  padding: EdgeInsets.only(
//                    bottom: 15,
//                    top: 5,
//                  ),
//                  itemCount: snapshot.data.documents.length,
//                  scrollDirection: Axis.vertical,
//                  itemBuilder: (context, index) {
//                    if (DateTime.now().isBefore(snapshot
//                        .data.documents[index].data['endTime']
//                        .toDate())) {
//                      return Card(
//                        shape: RoundedRectangleBorder(
//                          borderRadius: BorderRadius.circular(10.0),
//                        ),
//                        child: InkWell(
//                          onTap: () => navigateToEventDetails(widget.gid,
//                              snapshot.data.documents[index].data['eid']),
//                          splashColor: Colors.indigoAccent,
//                          child: Row(
//                            children: <Widget>[
//                              Container(
//                                child: Padding(
//                                  padding: const EdgeInsets.only(left: 20),
//                                  child: Column(
//                                      crossAxisAlignment:
//                                      CrossAxisAlignment.center,
//                                      children: <Widget>[
//                                        Text(
//                                          DateFormat('MMM').format(snapshot
//                                              .data
//                                              .documents[index]
//                                              .data['startTime']
//                                              .toDate()),
//                                          style: TextStyle(fontSize: 20),
//                                        ),
//                                        Padding(
//                                          padding: const EdgeInsets.fromLTRB(
//                                              0, 2, 0, 0),
//                                          child: Text(
//                                            DateFormat('d').format(snapshot
//                                                .data
//                                                .documents[index]
//                                                .data['startTime']
//                                                .toDate()),
//                                            style: TextStyle(fontSize: 20),
//                                          ),
//                                        ),
//                                      ]),
//                                ),
//                              ),
//                              Expanded(
//                                child: ListTile(
//                                  title: Text(
//                                    snapshot.data.documents[index].data['name'],
//                                    style: TextStyle(
//                                        fontFamily: AppTheme.fontName,
//                                        fontWeight: FontWeight.w700,
//                                        letterSpacing: 1.2,
//                                        color: AppTheme.darkerText),
//                                  ),
//                                  subtitle: Text(DateFormat('h:mm a').format(
//                                      snapshot.data.documents[index]
//                                          .data['startTime']
//                                          .toDate()) +
//                                      ' - ' +
//                                      DateFormat('h:mm a').format(snapshot
//                                          .data.documents[index].data['endTime']
//                                          .toDate())),
//                                ),
//                              ),
//                              IconButton(
//                                icon: Icon(
//                                  Icons.delete,
//                                  color: Colors.grey[400],
//                                ),
//                                onPressed: () {
//                                  _showDialogDelete(
//                                      widget.gid,
//                                      snapshot
//                                          .data.documents[index].data['eid']);
//                                },
//                              )
//                            ],
//                          ),
//                        ),
//                      );
//                    } else {
//                      return Container();
//                    }
//                  },
//                ),
//              );
//            }),
////        Padding(
////          padding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
////          child: Text(
////            'Past Events',
////            style: TextStyle(
////                fontSize: 20,
////                fontFamily: AppTheme.fontName,
////                fontWeight: FontWeight.w700,
////                letterSpacing: 1.2,
////                color: AppTheme.darkerText),
////          ),
////        ),
//        StreamBuilder(
//            stream: authService.getGroupEventsPast(widget.gid),
//            builder: (context, snapshot) {
//              if (!snapshot.hasData) {
//                return Container();
//              }
//              return Expanded(
//                child: ListView.builder(
//                  padding: EdgeInsets.only(
//                    bottom: 30,
//                    top: 5,
//                  ),
//                  itemCount: snapshot.data.documents.length,
//                  scrollDirection: Axis.vertical,
//                  itemBuilder: (context, index) {
//                    if (DateTime.now().isAfter(snapshot
//                        .data.documents[index].data['endTime']
//                        .toDate())) {
//                      return Card(
//                        color: Colors.grey,
//                        shape: RoundedRectangleBorder(
//                          borderRadius: BorderRadius.circular(10.0),
//                        ),
//                        child: InkWell(
//                          onTap: () => navigateToEventDetails(widget.gid,
//                              snapshot.data.documents[index].data['eid']),
//                          splashColor: Colors.indigoAccent,
//                          child: Row(
//                            children: <Widget>[
//                              Container(
//                                child: Padding(
//                                  padding: const EdgeInsets.only(left: 20),
//                                  child: Column(
//                                      crossAxisAlignment:
//                                      CrossAxisAlignment.center,
//                                      children: <Widget>[
//                                        Text(
//                                          DateFormat('MMM').format(snapshot
//                                              .data
//                                              .documents[index]
//                                              .data['startTime']
//                                              .toDate()),
//                                          style: TextStyle(fontSize: 20),
//                                        ),
//                                        Padding(
//                                          padding: const EdgeInsets.fromLTRB(
//                                              0, 2, 0, 0),
//                                          child: Text(
//                                            DateFormat('d').format(snapshot
//                                                .data
//                                                .documents[index]
//                                                .data['startTime']
//                                                .toDate()),
//                                            style: TextStyle(fontSize: 20),
//                                          ),
//                                        ),
//                                      ]),
//                                ),
//                              ),
//                              Expanded(
//                                child: ListTile(
//                                  title: Text(
//                                    snapshot.data.documents[index].data['name'],
//                                    style: TextStyle(
//                                        fontFamily: AppTheme.fontName,
//                                        fontWeight: FontWeight.w700,
//                                        letterSpacing: 1.2,
//                                        color: AppTheme.darkerText),
//                                  ),
//                                  subtitle: Text(DateFormat('h:mm a').format(
//                                      snapshot.data.documents[index]
//                                          .data['startTime']
//                                          .toDate()) +
//                                      ' - ' +
//                                      DateFormat('h:mm a').format(snapshot
//                                          .data.documents[index].data['endTime']
//                                          .toDate())),
//                                ),
//                              ),
//                              IconButton(
//                                icon: Icon(
//                                  Icons.delete,
//                                  color: AppTheme.darkerText,
//                                ),
//                                onPressed: () {
//                                  _showDialogDelete(
//                                      widget.gid,
//                                      snapshot
//                                          .data.documents[index].data['eid']);
//                                },
//                              )
//                            ],
//                          ),
//                        ),
//                      );
//                    } else {
//                      return Container();
//                    }
//                  },
//                ),
//              );
//            }),
//      ]),
//    );
//  }
//
//  Widget getAppBarUI() {
//    return AppBar(
//      title: Text('Events'),
//      backgroundColor: Colors.indigoAccent,
//      actions: <Widget>[
//        IconButton(
//          icon: Icon(Icons.add),
//          onPressed: () => navigateToAddEvent(widget.gid),
//        )
//      ],
//    );
//  }
//
//  navigateToEventDetails(String gid, String eid) {
//    Navigator.push(
//        context,
//        MaterialPageRoute(
//            builder: (context) => EventDetailPage(
//              gid: gid,
//              eid: eid,
//            )));
//  }
//
//  navigateToAddEvent(String gid) {
//    Navigator.push(
//        context,
//        MaterialPageRoute(
//            builder: (context) => AddEventScreen(
//              gid: gid,
//            )));
//  }
//
//  void _showDialogDelete(String gid, String eid) {
//    showDialog(
//      context: context,
//      builder: (BuildContext context) {
//        return AlertDialog(
//          contentPadding: EdgeInsets.fromLTRB(20, 30, 20, 0),
//          content: Text(
//            'Are you sure you want to delete this event',
//            textAlign: TextAlign.center,
//          ),
//          actions: <Widget>[
//            FlatButton(
//              child: Text('Okay'),
//              onPressed: () {
//                authService.deleteEvent(gid, eid);
//                Navigator.of(context).pop();
//              },
//            ),
//            FlatButton(
//              child: Text('Cancel'),
//              onPressed: () {
//                Navigator.of(context).pop();
//              },
//            ),
//          ],
//        );
//      },
//    );
//  }
//}
