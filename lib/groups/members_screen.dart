import 'package:flutter/material.dart';
import 'package:scanned/auth.dart';
import '../app_theme.dart';

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
      backgroundColor: AppTheme.background,
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
              return StreamBuilder(
                  stream: authService.getUserData(widget.gid),
                  builder: (context, snapshot1) {
                    if (!snapshot1.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return ListView.builder(
                      padding: EdgeInsets.only(
                        top: 16,
                      ),
                      itemCount: snapshot.data.documents.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        if (snapshot1.data['status'] == 'owner') {
                          if (snapshot.data.documents[index].data['status'] !=
                              'owner') {
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: ListTile(
                                title: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        snapshot
                                            .data.documents[index].data['name'],
                                        style: TextStyle(
                                          fontFamily: AppTheme.fontName,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 1.2,
                                          color: AppTheme.darkerText,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 4),
                                      child: Text(
                                        snapshot.data.documents[index]
                                            .data['status'],
                                        style: TextStyle(
                                          fontFamily: AppTheme.fontName,
                                          letterSpacing: 1.2,
                                          color: AppTheme.lightText,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.keyboard_arrow_up,
                                        color: Colors.grey[400],
                                      ),
                                      onPressed: () {
                                        _showDialogPromote(
                                            widget.gid,
                                            snapshot.data.documents[index]
                                                .data['uid']);
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.keyboard_arrow_down,
                                        color: Colors.grey[400],
                                      ),
                                      onPressed: () {
                                        _showDialogDemote(
                                            widget.gid,
                                            snapshot.data.documents[index]
                                                .data['uid']);
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.grey[400],
                                      ),
                                      onPressed: () {
                                        _showDialogDelete(
                                            widget.gid,
                                            snapshot.data.documents[index]
                                                .data['uid']);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: ListTile(
                                title: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        snapshot
                                            .data.documents[index].data['name'],
                                        style: TextStyle(
                                          fontFamily: AppTheme.fontName,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 1.2,
                                          color: AppTheme.darkerText,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 0),
                                      child: Text(
                                        snapshot.data.documents[index]
                                            .data['status'],
                                        style: TextStyle(
                                          fontFamily: AppTheme.fontName,
                                          letterSpacing: 1.2,
                                          color: AppTheme.lightText,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        } else {
                          if (snapshot.data.documents[index].data['status'] !=
                              'owner') {
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: ListTile(
                                title: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        snapshot
                                            .data.documents[index].data['name'],
                                        style: TextStyle(
                                          fontFamily: AppTheme.fontName,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 1.2,
                                          color: AppTheme.darkerText,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 4),
                                      child: Text(
                                        snapshot.data.documents[index]
                                            .data['status'],
                                        style: TextStyle(
                                          fontFamily: AppTheme.fontName,
                                          letterSpacing: 1.2,
                                          color: AppTheme.lightText,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.grey[400],
                                      ),
                                      onPressed: () {
                                        _showDialogDelete(
                                            widget.gid,
                                            snapshot.data.documents[index]
                                                .data['uid']);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: ListTile(
                                title: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        snapshot
                                            .data.documents[index].data['name'],
                                        style: TextStyle(
                                          fontFamily: AppTheme.fontName,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 1.2,
                                          color: AppTheme.darkerText,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 0),
                                      child: Text(
                                        snapshot.data.documents[index]
                                            .data['status'],
                                        style: TextStyle(
                                          fontFamily: AppTheme.fontName,
                                          letterSpacing: 1.2,
                                          color: AppTheme.lightText,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        }
                      },
                    );
                  });
            }
          }),
    );
  }

  void _showDialogDelete(String gid, String mid) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.fromLTRB(20, 30, 20, 0),
          content: Text(
            'Are you sure you want to delete this member',
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Okay'),
              onPressed: () {
                authService.deleteMember(gid, mid);
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDialogDemote(String gid, String mid) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.fromLTRB(20, 30, 20, 0),
          content: Text(
            'Are you sure you want to demote this member',
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Okay'),
              onPressed: () {
                authService.demoteMember(gid, mid);
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDialogPromote(String gid, String mid) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.fromLTRB(20, 30, 20, 0),
          content: Text(
            'Are you sure you want to promote this member',
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Okay'),
              onPressed: () {
                authService.promoteMember(gid, mid);
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
