import 'package:flutter/material.dart';
import '../auth.dart';
import '../fintness_app_theme.dart';
import 'package:qr_flutter/qr_flutter.dart';

class EventDetailPage extends StatefulWidget {
  final String gid;
  final String eid;

  EventDetailPage({this.gid, this.eid});

  @override
  _EventDetailPage createState() => _EventDetailPage();
}

class _EventDetailPage extends State<EventDetailPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: authService.getGroupEventDetails(widget.gid, widget.eid),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Scaffold(
              backgroundColor: FintnessAppTheme.background,
              appBar: AppBar(
                backgroundColor: Colors.indigoAccent,
                title: Text(snapshot.data['name']),
                actions: <Widget>[
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.file_download),
                  )
                ],
              ),
              body: Column(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(80.0),
                  child: Center(
                    child: QrImage(
                      data: widget.gid + '+' + widget.eid,
                      version: QrVersions.auto,
                      size: 200,
                    ),
                  ),
                ),
                Expanded(
                  child: StreamBuilder(
                      stream: authService.getGroupEventAttendees(
                          widget.gid, widget.eid),
                      builder: (context, snapshot1) {
                        if (!snapshot1.hasData) {
                          return Center(child: CircularProgressIndicator());
                        }
                        return ListView.builder(
                          itemCount: snapshot1.data.documents.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            if (snapshot1
                                .data.documents[index].data['attended']) {
                              return Card(
                                color: Colors.indigoAccent,
                                child: ListTile(
                                  title: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Text(
                                          snapshot1.data.documents[index]
                                              .data['name'],
                                          style: TextStyle(
                                            fontFamily:
                                                FintnessAppTheme.fontName,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 1.2,
                                            color: FintnessAppTheme.darkerText,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              return Card(
                                color: Colors.grey,
                                child: ListTile(
                                  title: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Text(
                                          snapshot1.data.documents[index]
                                              .data['name'],
                                          style: TextStyle(
                                            fontFamily:
                                                FintnessAppTheme.fontName,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 1.2,
                                            color: FintnessAppTheme.darkerText,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                          },
                        );
                      }),
                ),
              ]),
            );
          }
        });
  }
}
