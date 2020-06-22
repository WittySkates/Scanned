import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../auth.dart';
import '../app_theme.dart';
import 'package:scanned/groups/members_screen.dart';
import 'package:scanned/groups/events_screen.dart';
import 'package:intl/intl.dart';

class GroupDetailPage extends StatefulWidget {
  final DocumentSnapshot post;

  GroupDetailPage({this.post});

  @override
  _GroupDetailPage createState() => _GroupDetailPage();
}

class _GroupDetailPage extends State<GroupDetailPage> {
  Widget tabBody = Container(
    color: AppTheme.background,
  );

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: authService.getGroupCounts(widget.post.data['gid']),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Container(color: AppTheme.background),
            );
          } else {
            if (widget.post.data['status'] == 'owner' ||
                widget.post.data['status'] == 'admin') {
              return Scaffold(
                backgroundColor: AppTheme.background,
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
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
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
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
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
            } else {
              return Scaffold(
                appBar: AppBar(
                  title: Text('Events'),
                  backgroundColor: Colors.indigoAccent,
                ),
                body: StreamBuilder(
                    stream: authService.getGroupEvents(widget.post.data['gid']),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return ListView.builder(
                          padding: EdgeInsets.only(
                            top: 16,
                          ),
                          itemCount: snapshot.data.documents.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          15, 20, 15, 20),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              DateFormat('MMM').format(snapshot
                                                  .data
                                                  .documents[index]
                                                  .data['startTime']
                                                  .toDate()),
                                              style: TextStyle(fontSize: 20),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 2, 0, 0),
                                              child: Text(
                                                DateFormat('d').format(snapshot
                                                    .data
                                                    .documents[index]
                                                    .data['startTime']
                                                    .toDate()),
                                                style: TextStyle(fontSize: 20),
                                              ),
                                            ),
                                          ]),
                                    ),
                                  ),
                                  Expanded(
                                    child: ListTile(
                                      title: Text(
                                        snapshot
                                            .data.documents[index].data['name'],
                                        style: TextStyle(
                                            fontFamily: AppTheme.fontName,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 1.2,
                                            color: AppTheme.darkerText),
                                      ),
                                      subtitle: Text(DateFormat('h:mm a')
                                              .format(snapshot
                                                  .data
                                                  .documents[index]
                                                  .data['startTime']
                                                  .toDate()) +
                                          ' - ' +
                                          DateFormat('h:mm a').format(snapshot
                                              .data
                                              .documents[index]
                                              .data['endTime']
                                              .toDate())),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }
                    }),
              );
            }
          }
        });
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
