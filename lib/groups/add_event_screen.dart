import 'package:flutter/material.dart';
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
  DateTime start = DateTime.now();
  DateTime end = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Your Event'),
        backgroundColor: Colors.indigoAccent,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                  icon: Icon(Icons.description), labelText: 'Name'),
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Center(
                child: RaisedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      authService.addEvent(widget.gid, name, start, end);
                      Navigator.pop(context, 'GroupScreen');
                    }
                  },
                  child: Text('Submit'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
