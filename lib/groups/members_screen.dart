import 'package:flutter/material.dart';
import 'package:scanned/auth.dart';
import '../fintness_app_theme.dart';

class MembersScreen extends StatefulWidget {
  const MembersScreen({Key key, this.animationController, this.gid})
      : super(key: key);
  final AnimationController animationController;

  final String gid;

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
      body: StreamBuilder(
          stream: authService.getGroupMembers(widget.gid),
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
                    child: ListTile(
                      title: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              snapshot.data.documents[index].data['name'],
                              style: TextStyle(
                                fontFamily: FintnessAppTheme.fontName,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.2,
                                color: FintnessAppTheme.darkerText,
                              ),
                            ),
                          ),
                          Text(
                            snapshot.data.documents[index].data['status'],
                            style: TextStyle(
                              fontFamily: FintnessAppTheme.fontName,
                              letterSpacing: 1.2,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          }),
    );
  }
}
