import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../auth.dart';
import '../fintness_app_theme.dart';
import 'package:scanned/groups/members_screen.dart';
import 'package:scanned/groups/events_screen.dart';

class DetailPage extends StatefulWidget {
  final DocumentSnapshot post;

  DetailPage({this.post});

  @override
  _DetailPage createState() => _DetailPage();
}

class _DetailPage extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    if (widget.post.data['owned'] == true ||
        widget.post.data['admin'] == true) {
      return FutureBuilder(
          future: Future.wait([
            authService.getGroupMembers(widget.post.data['gid']),
            authService.getGroupEvents(widget.post.data['gid']),
            authService.getGroupCounts(widget.post.data['gid'])
          ]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: SizedBox(),
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
                    SizedBox(
                      height: 200,
                      child: Card(
                        child: InkWell(
                            onTap: () =>
                                navigateToMembersPage(snapshot.data[0]),
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
                                        child: Text(snapshot.data[2]
                                                ['memberCount']
                                            .toString())),
                                  ),
                                ],
                              ),
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 200,
                      child: Card(
                        child: InkWell(
                            onTap: () => navigateToEventsPage(
                                snapshot.data[1], widget.post.data['gid']),
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
                                      child: Text(snapshot.data[2]['eventCount']
                                          .toString()),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ),
                    ),
                  ],
                ),
              );
            }
          });
    } else {
      return Text('No Buddy');
    }
  }

  navigateToMembersPage(List<DocumentSnapshot> post) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MembersScreen(
                  post: post,
                )));
  }

  navigateToEventsPage(List<DocumentSnapshot> post, String gid) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EventsScreen(
                  post: post,
                  gid: gid,
                )));
  }
}
