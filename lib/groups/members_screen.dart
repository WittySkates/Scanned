import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scanned/groups/group_detail_view.dart';
import 'package:flutter/material.dart';
import '../auth.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../fintness_app_theme.dart';

class MembersScreen extends StatefulWidget {
  const MembersScreen({Key key, this.animationController, this.post})
      : super(key: key);
  final AnimationController animationController;

  final List<DocumentSnapshot> post;

  @override
  _MembersScreenState createState() => _MembersScreenState();
}

class _MembersScreenState extends State<MembersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Members'),
        backgroundColor: Colors.indigoAccent,
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

  Widget getAppBarUI() {
    return AppBar(
      title: Text('Groups'),
      backgroundColor: Colors.indigoAccent,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => authService.createGroup(
              'NHS', 'United States', 'Florida', 'Oldsmar'),
        )
      ],
    );
  }
}
