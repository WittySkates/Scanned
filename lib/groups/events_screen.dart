import 'package:flutter/material.dart';
import 'package:scanned/groups/event_details_screen.dart';
import 'package:scanned/groups/add_event_screen.dart';
import 'package:intl/intl.dart';
import '../app_theme.dart';
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
      backgroundColor: AppTheme.background,
      appBar: getAppBarUI(),
      body: StreamBuilder(
          stream: authService.getGroupEventsPast(widget.gid),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container();
            }
            return FutureBuilder(
                future: authService.getNextEventDocument(widget.gid),
                builder: (context, snapshotdoc) {
                  if (!snapshotdoc.hasData) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: ListView.builder(
                        padding: EdgeInsets.only(
                          bottom: 15,
                          top: 5,
                        ),
                        itemCount: snapshot.data.documents.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          if (DateTime.now().isBefore(snapshot
                              .data.documents[index].data['endTime']
                              .toDate())) {
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: InkWell(
                                onTap: () => navigateToEventDetails(widget.gid,
                                    snapshot.data.documents[index].data['eid']),
                                splashColor: Colors.indigoAccent,
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 20),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                DateFormat('MMM').format(
                                                    snapshot
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
                                                  DateFormat('d').format(
                                                      snapshot
                                                          .data
                                                          .documents[index]
                                                          .data['startTime']
                                                          .toDate()),
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                ),
                                              ),
                                            ]),
                                      ),
                                    ),
                                    Expanded(
                                      child: ListTile(
                                        title: Text(
                                          snapshot.data.documents[index]
                                              .data['name'],
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
                                    IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.grey[400],
                                      ),
                                      onPressed: () {
                                        _showDialogDelete(
                                            widget.gid,
                                            snapshot.data.documents[index]
                                                .data['eid']);
                                      },
                                    )
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return Card(
                              color: Colors.grey,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: InkWell(
                                onTap: () => navigateToEventDetails(widget.gid,
                                    snapshot.data.documents[index].data['eid']),
                                splashColor: Colors.indigoAccent,
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 20),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                DateFormat('MMM').format(
                                                    snapshot
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
                                                  DateFormat('d').format(
                                                      snapshot
                                                          .data
                                                          .documents[index]
                                                          .data['startTime']
                                                          .toDate()),
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                ),
                                              ),
                                            ]),
                                      ),
                                    ),
                                    Expanded(
                                      child: ListTile(
                                        title: Text(
                                          snapshot.data.documents[index]
                                              .data['name'],
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
                                    IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: AppTheme.darkerText,
                                      ),
                                      onPressed: () {
                                        _showDialogDelete(
                                            widget.gid,
                                            snapshot.data.documents[index]
                                                .data['eid']);
                                      },
                                    )
                                  ],
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    );
                  }
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                          child: Text(
                            'Next Event',
                            style: TextStyle(
                                fontSize: 20,
                                fontFamily: AppTheme.fontName,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.2,
                                color: AppTheme.darkerText),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 20),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: InkWell(
                              onTap: () => navigateToEventDetails(
                                  widget.gid, snapshotdoc.data['eid']),
                              splashColor: Colors.indigoAccent,
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 20),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              DateFormat('MMM').format(
                                                  snapshotdoc.data['startTime']
                                                      .toDate()),
                                              style: TextStyle(fontSize: 20),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 2, 0, 0),
                                              child: Text(
                                                DateFormat('d').format(
                                                    snapshotdoc
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
                                        snapshotdoc.data['name'],
                                        style: TextStyle(
                                            fontFamily: AppTheme.fontName,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 1.2,
                                            color: AppTheme.darkerText),
                                      ),
                                      subtitle: Text(DateFormat('h:mm a')
                                              .format(snapshotdoc
                                                  .data['startTime']
                                                  .toDate()) +
                                          ' - ' +
                                          DateFormat('h:mm a').format(
                                              snapshotdoc.data['endTime']
                                                  .toDate())),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.grey[400],
                                    ),
                                    onPressed: () {
                                      _showDialogDelete(
                                          widget.gid, snapshotdoc.data['eid']);
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            padding: EdgeInsets.only(
                              bottom: 15,
                              top: 5,
                            ),
                            itemCount: snapshot.data.documents.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              if (DateTime.now().isBefore(snapshot
                                  .data.documents[index].data['endTime']
                                  .toDate())) {
                                return Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: InkWell(
                                    onTap: () => navigateToEventDetails(
                                        widget.gid,
                                        snapshot
                                            .data.documents[index].data['eid']),
                                    splashColor: Colors.indigoAccent,
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 20),
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    DateFormat('MMM').format(
                                                        snapshot
                                                            .data
                                                            .documents[index]
                                                            .data['startTime']
                                                            .toDate()),
                                                    style:
                                                        TextStyle(fontSize: 20),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(0, 2, 0, 0),
                                                    child: Text(
                                                      DateFormat('d').format(
                                                          snapshot
                                                              .data
                                                              .documents[index]
                                                              .data['startTime']
                                                              .toDate()),
                                                      style: TextStyle(
                                                          fontSize: 20),
                                                    ),
                                                  ),
                                                ]),
                                          ),
                                        ),
                                        Expanded(
                                          child: ListTile(
                                            title: Text(
                                              snapshot.data.documents[index]
                                                  .data['name'],
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
                                                DateFormat('h:mm a').format(
                                                    snapshot
                                                        .data
                                                        .documents[index]
                                                        .data['endTime']
                                                        .toDate())),
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
                                                    .data['eid']);
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                return Card(
                                  color: Colors.grey,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: InkWell(
                                    onTap: () => navigateToEventDetails(
                                        widget.gid,
                                        snapshot
                                            .data.documents[index].data['eid']),
                                    splashColor: Colors.indigoAccent,
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 20),
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    DateFormat('MMM').format(
                                                        snapshot
                                                            .data
                                                            .documents[index]
                                                            .data['startTime']
                                                            .toDate()),
                                                    style:
                                                        TextStyle(fontSize: 20),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(0, 2, 0, 0),
                                                    child: Text(
                                                      DateFormat('d').format(
                                                          snapshot
                                                              .data
                                                              .documents[index]
                                                              .data['startTime']
                                                              .toDate()),
                                                      style: TextStyle(
                                                          fontSize: 20),
                                                    ),
                                                  ),
                                                ]),
                                          ),
                                        ),
                                        Expanded(
                                          child: ListTile(
                                            title: Text(
                                              snapshot.data.documents[index]
                                                  .data['name'],
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
                                                DateFormat('h:mm a').format(
                                                    snapshot
                                                        .data
                                                        .documents[index]
                                                        .data['endTime']
                                                        .toDate())),
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.delete,
                                            color: AppTheme.darkerText,
                                          ),
                                          onPressed: () {
                                            _showDialogDelete(
                                                widget.gid,
                                                snapshot.data.documents[index]
                                                    .data['eid']);
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                );
                                ;
                              }
                            },
                          ),
                        ),
                      ]);
                });
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

  void _showDialogDelete(String gid, String eid) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.fromLTRB(20, 30, 20, 0),
          content: Text(
            'Are you sure you want to delete this event',
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Okay'),
              onPressed: () {
                authService.deleteEvent(gid, eid);
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
