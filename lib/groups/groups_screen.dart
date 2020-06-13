import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scanned/groups/group_detail_view.dart';
import 'package:scanned/groups/add_group_screen.dart';
import 'package:flutter/material.dart';
import '../auth.dart';
import '../fintness_app_theme.dart';

class GroupScreen extends StatefulWidget {
  const GroupScreen({Key key, this.animationController}) : super(key: key);
  final AnimationController animationController;
  @override
  _GroupScreenState createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: FintnessAppTheme.background,
      child: Scaffold(
        appBar: getAppBarUI(),
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            getMainListViewUI(),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom,
            )
          ],
        ),
      ),
    );
  }

  navigateToAddGroupPage() async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddGroupScreen()));
  }

  navigateToGroupPage(DocumentSnapshot post) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DetailPage(
                  post: post,
                )));
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
            padding: EdgeInsets.only(
              top: 16,
            ),
            itemCount: snapshot.data.documents.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              widget.animationController.forward();
              return Card(
                child: InkWell(
                  onTap: () =>
                      navigateToGroupPage(snapshot.data.documents[index]),
                  splashColor: Colors.indigo,
                  child: ListTile(
                      title: Text(snapshot.data.documents[index].data['name'])),
                ),
              );
            },
          );
        }
      },
    );
  }

  Widget getAppBarUI() {
    return AppBar(
      title: Text('Groups'),
      backgroundColor: Colors.indigoAccent,
      actions: <Widget>[
        IconButton(
            icon: Icon(Icons.add), onPressed: () => navigateToAddGroupPage())
      ],
    );
  }
}
