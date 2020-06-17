import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scanned/groups/group_detail_view.dart';
import 'package:scanned/groups/add_group_screen.dart';
import 'package:flutter/material.dart';
import '../auth.dart';
import '../app_theme.dart';
import 'package:intl/intl.dart';

class GroupScreen extends StatefulWidget {
  const GroupScreen({Key key, this.animationController}) : super(key: key);
  final AnimationController animationController;
  @override
  _GroupScreenState createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen>
    with TickerProviderStateMixin {
  Animation<double> topBarAnimation;

  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    widget.animationController.forward();
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));

    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            getMainListViewUI(),
            getAppBarUI(),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom,
            )
          ],
        ),
      ),
    );
  }

  Widget getMainListViewUI() {
    return StreamBuilder(
      stream: authService.getUsersGroups(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.builder(
            controller: scrollController,
            padding: EdgeInsets.only(
              top: AppBar().preferredSize.height +
                  MediaQuery.of(context).padding.top +
                  24,
              bottom: 62 + MediaQuery.of(context).padding.bottom,
            ),
            itemCount: snapshot.data.documents.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              if (snapshot.data.documents[index].data['status'] == 'owner') {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: InkWell(
                    onTap: () => navigateToGroupDetailsPage(
                        snapshot.data.documents[index]),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: ListTile(
                            title: Text(
                              snapshot.data.documents[index].data['name'],
                            ),
                            subtitle: FutureBuilder(
                                future: authService.getNextEvent(
                                    snapshot.data.documents[index].data['gid']),
                                builder: (context, snapshot1) {
                                  if (!snapshot1.hasData) {
                                    return SizedBox();
                                  }
                                  if (snapshot1.data == DateTime(9999)) {
                                    return Row(children: <Widget>[
                                      Expanded(
                                        child: Text('Next Event: '),
                                      ),
                                      Text('No Upcoming Events'),
                                    ]);
                                  }
                                  return Row(children: <Widget>[
                                    Expanded(
                                      child: Text('Next Event: '),
                                    ),
                                    Text(
                                      DateFormat('EE, MMMM d, yyyy')
                                          .format(snapshot1.data),
                                    ),
                                  ]);
                                }),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.grey[400],
                          ),
                          onPressed: () {
                            _showDialogDelete(
                                snapshot.data.documents[index].data['gid']);
                          },
                        )
                      ],
                    ),
                  ),
                );
              } else {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: InkWell(
                    onTap: () => navigateToGroupDetailsPage(
                        snapshot.data.documents[index]),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: ListTile(
                            title: Text(
                              snapshot.data.documents[index].data['name'],
                            ),
                            subtitle: FutureBuilder(
                                future: authService.getNextEvent(
                                    snapshot.data.documents[index].data['gid']),
                                builder: (context, snapshot1) {
                                  if (!snapshot1.hasData) {
                                    return SizedBox();
                                  }
                                  if (snapshot1.data == DateTime(9999)) {
                                    return Row(children: <Widget>[
                                      Expanded(
                                        child: Text('Next Event: '),
                                      ),
                                      Text('No Upcoming Events'),
                                    ]);
                                  }
                                  return Row(children: <Widget>[
                                    Expanded(
                                      child: Text('Next Event: '),
                                    ),
                                    Text(
                                      DateFormat('EE, MMMM d, yyyy')
                                          .format(snapshot1.data),
                                    ),
                                  ]);
                                }),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.grey[400],
                          ),
                          onPressed: () {
                            _showDialogLeave(
                                snapshot.data.documents[index].data['gid']);
                          },
                        )
                      ],
                    ),
                  ),
                );
              }
            },
          );
        }
      },
    );
  }

  Widget getAppBarUI() {
    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: widget.animationController,
          builder: (BuildContext context, Widget child) {
            return FadeTransition(
              opacity: topBarAnimation,
              child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 30 * (1.0 - topBarAnimation.value), 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.white.withOpacity(topBarOpacity),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(32.0),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: AppTheme.grey.withOpacity(0.4 * topBarOpacity),
                          offset: const Offset(1.1, 1.1),
                          blurRadius: 10.0),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).padding.top,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 16,
                            right: 16,
                            top: 16 - 8.0 * topBarOpacity,
                            bottom: 12 - 8.0 * topBarOpacity),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Groups',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontFamily: AppTheme.fontName,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 22 + 6 - 6 * topBarOpacity,
                                    letterSpacing: 1.2,
                                    color: AppTheme.darkerText,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 38,
                              width: 38,
                              child: InkWell(
                                highlightColor: Colors.transparent,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(32.0)),
                                onTap: () => navigateToAddGroupPage(),
                                child: Center(
                                  child: Icon(
                                    Icons.add,
                                    color: AppTheme.grey,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        )
      ],
    );
  }

  navigateToAddGroupPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddGroupScreen()));
  }

  navigateToGroupDetailsPage(DocumentSnapshot post) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => GroupDetailPage(
                  post: post,
                )));
  }

  void _showDialogDelete(String gid) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.fromLTRB(20, 30, 20, 0),
          content: Text(
            'Are you sure you want to delete this group',
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  authService.deleteGroup(gid);
                  Navigator.of(context).pop();
                }),
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDialogLeave(String gid) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.fromLTRB(20, 30, 20, 0),
          content: Text(
            'Are you sure you want to leave this group',
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  authService.leaveGroup(gid);
                  Navigator.of(context).pop();
                }),
            FlatButton(
              child: Text('Cancel'),
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
