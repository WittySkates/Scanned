import 'package:flutter/material.dart';
import '../auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddGroupScreen extends StatefulWidget {
  @override
  _MyCustomFormState createState() => _MyCustomFormState();
}

class _MyCustomFormState extends State<AddGroupScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = 'Test';
  String country = 'Test';
  String state = 'Test';
  String city = 'Test';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBarUI(),
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
            TextFormField(
              decoration: InputDecoration(
                  icon: Icon(Icons.description), labelText: 'Country'),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter the country';
                }
                setState(() {
                  country = value;
                });
                return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                  icon: Icon(Icons.description), labelText: 'State'),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter the state';
                }
                setState(() {
                  state = value;
                });
                return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                  icon: Icon(Icons.description), labelText: 'City'),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter the city';
                }
                setState(() {
                  city = value;
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
                      authService.createGroup(name, country, state, city);
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

  Widget getAppBarUI() {
    return AppBar(
      title: Text('Add Your Group'),
      backgroundColor: Colors.indigoAccent,
    );
  }
}
