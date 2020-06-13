import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scanned/groups/group_detail_view.dart';
import 'package:flutter/material.dart';
import '../auth.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../fintness_app_theme.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({Key key, this.animationController, this.post, this.gid})
      : super(key: key);
  final AnimationController animationController;

  final List<DocumentSnapshot> post;
  final String gid;

  @override
  _EventsScreen createState() => _EventsScreen();
}

class _EventsScreen extends State<EventsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Events'),
        backgroundColor: Colors.indigoAccent,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => authService.addEvent(
                widget.gid, 'Test', DateTime.now(), DateTime.now()),
          )
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.only(
          top: 16,
        ),
        itemCount: widget.post.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(title: Text(widget.post[index].data['name'])),
          );
        },
      ),
    );
  }
}
