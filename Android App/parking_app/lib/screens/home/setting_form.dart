import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parking_app/models/user.dart';
import 'package:parking_app/services/database.dart';
import 'package:parking_app/shared/constants.dart';
import 'package:parking_app/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class SettingForm extends StatefulWidget {
  const SettingForm({Key? key}) : super(key: key);

  @override
  State<SettingForm> createState() => _SettingFormState();
}

class _SettingFormState extends State<SettingForm> {
  final _formKey = GlobalKey<FormState>();

  String? _currentName;
  String? _currentBLE;
  String? _currentLicense;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserParam?>(context);
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return StreamBuilder<DocumentSnapshot>(
        stream: DatabaseService(uid: user?.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            DocumentSnapshot<Object?>? userData = snapshot.data;
            return Scaffold(
              resizeToAvoidBottomInset: false,
              body: SingleChildScrollView(
                reverse: true,
                child: Padding(
                  padding: EdgeInsets.only(bottom: bottom),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 20.0),

                        Text('Update Your Information',
                            style: TextStyle(fontSize: 20.0)),

                        SizedBox(height: 40.0),

                        TextFormField(
                          initialValue: userData!['name'],
                          decoration: InputDecoration(
                            labelText: "Name",
                            fillColor: Colors.white,
                            hintText: 'Enter your name',

                          ),
                          validator: (val) =>
                              val!.isEmpty ? 'Please enter a name' : null,
                          onChanged: (val) => setState(() => _currentName = val),
                        ),

                        SizedBox(height: 20),

                        TextFormField(
                          initialValue: userData['license_plate'],
                          decoration: InputDecoration(
                            labelText: "License Plate Number",
                            fillColor: Colors.white,
                            hintText: 'Enter your license plate number',

                          ),
                          validator: (val) =>
                              val!.isEmpty ? 'Please enter a license plate number' : null,
                          onChanged: (val) => setState(() => _currentLicense = val),
                        ),

                        SizedBox(height: 20.0),

                        TextFormField(
                          initialValue: userData['bluetooth_id'],
                          decoration: InputDecoration(
                            labelText: "Bluetooth ID",
                            fillColor: Colors.white,
                            hintText: 'Enter your bluetooth ID',

                          ),
                          validator: (val) =>
                              val!.isEmpty ? 'Please enter a bluetooth ID' : null,
                          onChanged: (val) => setState(() => _currentBLE = val),
                        ),

                        SizedBox(height: 40),

                        ElevatedButton(
                          child:
                              Text('Update', style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xffB62D2D),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await DatabaseService(uid: user?.uid).updateUserData(
                                _currentBLE ?? userData['bluetooth_id'],
                                _currentName ?? userData['name'],
                                _currentLicense ?? userData['license_plate'],
                              );
                              print(_currentBLE);
                              print(_currentName);
                              print(_currentLicense);
                              Navigator.pop(context);
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
            return Loading();
          }
        });
  }
}
