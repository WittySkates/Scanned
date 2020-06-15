import 'package:flutter/material.dart';
import 'package:scanned/groups/event_details_screen.dart';
import 'package:scanned/groups/add_event_screen.dart';

import '../auth.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({Key key, this.animationController, this.gid})
      : super(key: key);
  final AnimationController animationController;
  final String gid;
  @override
  _EventsScreen createState() => _EventsScreen();
}

class _EventsScreen extends State<EventsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBarUI(),
      body: StreamBuilder(
          stream: authService.getGroupEvents(widget.gid),
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
                    child: InkWell(
                      onTap: () => navigateToEventDetails(widget.gid,
                          snapshot.data.documents[index].data['eid']),
                      splashColor: Colors.indigoAccent,
                      child: ListTile(
                          title: Text(
                              snapshot.data.documents[index].data['name'])),
                    ),
                  );
                },
              );
            }
          }),
    );
  }

  Widget getAppBarUI() {
    return AppBar(
      title: Text('Events'),
      backgroundColor: Colors.indigoAccent,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => navigateToAddEvent(widget.gid),
        )
      ],
    );
  }

  navigateToEventDetails(String gid, String eid) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EventDetailPage(
                  gid: gid,
                  eid: eid,
                )));
  }

  navigateToAddEvent(String gid) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddEventScreen(
                  gid: gid,
                )));
  }
}
