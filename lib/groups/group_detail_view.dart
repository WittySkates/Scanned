import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../auth.dart';
import '../fintness_app_theme.dart';
import 'package:scanned/groups/members_screen.dart';
import 'package:scanned/groups/events_screen.dart';

class GroupDetailPage extends StatefulWidget {
  final DocumentSnapshot post;

  GroupDetailPage({this.post});

  @override
  _GroupDetailPage createState() => _GroupDetailPage();
}

class _GroupDetailPage extends State<GroupDetailPage> {
  Widget tabBody = Container(
    color: FintnessAppTheme.background,
  );

  @override
  Widget build(BuildContext context) {
    if (widget.post.data['status'] == 'owner' ||
        widget.post.data['status'] == 'admin') {
      return StreamBuilder(
          stream: authService.getGroupCounts(widget.post.data['gid']),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: Container(color: FintnessAppTheme.background),
              );
            } else {
              return Scaffold(
                backgroundColor: FintnessAppTheme.background,
                appBar: AppBar(
                  backgroundColor: Colors.indigoAccent,
                  title: Text(widget.post.data['name']),
                ),
                body: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(80.0),
                      child: Center(
                        child: QrImage(
                          data: widget.post.data['gid'],
                          version: QrVersions.auto,
                          size: 200,
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Card(
                        child: InkWell(
                            onTap: () =>
                                navigateToMembersPage(widget.post.data['gid']),
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Text('Members'),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                        child: Text(snapshot.data['memberCount']
                                            .toString())),
                                  ),
                                ],
                              ),
                            )),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Card(
                        child: InkWell(
                            onTap: () =>
                                navigateToEventsPage(widget.post.data['gid']),
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Text('Events'),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Text(snapshot.data['eventCount']
                                          .toString()),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    )
                  ],
                ),
              );
            }
          });
    } else {
      return Text('No Buddy');
    }
  }

  navigateToMembersPage(String gid) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MembersScreen(
                  gid: gid,
                )));
  }

  navigateToEventsPage(String gid) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EventsScreen(
                  gid: gid,
                )));
  }
}
