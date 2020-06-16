import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import '../auth.dart';

class AddEventScreen extends StatefulWidget {
  AddEventScreen({this.gid});
  final String gid;
  @override
  _AddEventScreen createState() => _AddEventScreen();
}

class _AddEventScreen extends State<AddEventScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = 'Test';

  DateTime startTime;
  DateTime endTime;

  String startTimeDateShown;
  String endTimeDateShown;

  String startTimeShown;
  String endTimeShown;

  @override
  void initState() {
    startTime = DateTime.now();
    endTime = DateTime.now();

    startTimeDateShown = DateFormat('EE, MMMM d, yyyy').format(startTime);
    endTimeDateShown = DateFormat('EE, MMMM d, yyyy').format(endTime);

    startTimeShown = DateFormat('h:mm a').format(startTime);
    endTimeShown = DateFormat('h:mm a').format(endTime);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Your Event'),
        backgroundColor: Colors.indigoAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 50),
                child: SizedBox(
                  height: 80,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'Name'),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter the name';
                          }
                          setState(() {
                            name = value;
                          });
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Center(
                  child: Text(
                    'This is when attendants can scan the QR to sign in.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: InkWell(
                  onTap: () {
                    DatePicker.showDateTimePicker(
                      context,
                      showTitleActions: true,
                      minTime: DateTime.now(),
                      maxTime: DateTime(9999),
                      onChanged: (date) {
                        setState(() {
                          startTime = date;
                          startTimeDateShown =
                              DateFormat('EE, MMMM d, yyyy').format(date);
                          startTimeShown = DateFormat('h:mm a').format(date);
                        });
                      },
                      onConfirm: (date) {
                        setState(() {
                          startTime = date;
                          startTimeDateShown =
                              DateFormat('EE, MMMM d, yyyy').format(date);
                          startTimeShown = DateFormat('h:mm a').format(date);

                          endTime = date.add(Duration(minutes: 1));
                          endTimeDateShown =
                              DateFormat('EE, MMMM d, yyyy').format(endTime);
                          endTimeShown = DateFormat('h:mm a').format(endTime);
                        });
                      },
                    );
                  },
                  child: ListTile(
                    leading: Icon(
                      Icons.play_arrow,
                      color: Colors.indigoAccent,
                    ),
                    title: Row(
                      children: <Widget>[
                        Expanded(child: Text(startTimeDateShown)),
                        Text(startTimeShown)
                      ],
                    ),
                  ),
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: InkWell(
                  onTap: () {
                    DatePicker.showDateTimePicker(
                      context,
                      showTitleActions: true,
                      minTime: startTime.add(Duration(minutes: 1)),
                      maxTime: DateTime(9999),
                      onChanged: (date) {
                        setState(() {
                          endTime = date;
                          endTimeDateShown =
                              DateFormat('EE, MMMM d, yyyy').format(date);
                          endTimeShown = DateFormat('h:mm a').format(date);
                        });
                      },
                      onConfirm: (date) {
                        setState(() {
                          endTime = date;
                          endTimeDateShown =
                              DateFormat('EE, MMMM d, yyyy').format(date);
                          endTimeShown = DateFormat('h:mm a').format(date);
                        });
                      },
                    );
                  },
                  child: ListTile(
                    leading: Icon(
                      Icons.stop,
                      color: Colors.grey,
                    ),
                    title: Row(
                      children: <Widget>[
                        Expanded(child: Text(endTimeDateShown)),
                        Text(endTimeShown)
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  child: RaisedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        authService.addEvent(
                            widget.gid, name, startTime, endTime);
                        Navigator.pop(context, 'GroupScreen');
                      }
                    },
                    color: Colors.indigoAccent,
                    child: Text(
                      'Submit',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
