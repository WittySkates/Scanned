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
        stream: authService.getGroupEventsDetails(widget.gid, widget.eid),
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
              body: Column(
                children: <Widget>[
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
                ],
              ),
            );
          }
        });
  }
}
