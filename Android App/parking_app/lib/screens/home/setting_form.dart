import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parking_app/models/user.dart';
import 'package:parking_app/services/database.dart';
import 'package:parking_app/shared/constants.dart';
import 'package:parking_app/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingForm extends StatefulWidget {
  final int index;

  const SettingForm({Key? key, required this.index}) : super(key: key);

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
            var data = userData!.data() as Map<String, dynamic>;
            // print(data.keys.toList().toString());
            // print(widget.index.toString());
            // print(data.keys
            //     .toList()
            //     .toString()
            //     .contains(widget.index.toString()));
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
                        const SizedBox(height: 20.0),
                        const Text('Update Your Information',
                            style: const TextStyle(fontSize: 20.0)),
                        const SizedBox(height: 40.0),
                        TextFormField(
                          initialValue: data.keys
                                  .toList()
                                  .toString()
                                  .contains(widget.index.toString())
                              ? userData[widget.index.toString()]['name']
                              : '',
                          decoration: const InputDecoration(
                            labelText: "Name",
                            fillColor: Colors.white,
                            hintText: 'Enter your name',
                          ),
                          validator: (val) =>
                              val!.isEmpty ? 'Please enter a name' : null,
                          onChanged: (val) =>
                              setState(() => _currentName = val),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          initialValue: data.keys
                                  .toList()
                                  .toString()
                                  .contains(widget.index.toString())
                              ? userData[widget.index.toString()]
                                  ['license_plate']
                              : '',
                          decoration: const InputDecoration(
                            labelText: "License Plate Number",
                            fillColor: Colors.white,
                            hintText: 'Enter your license plate number',
                          ),
                          validator: (val) => val!.isEmpty
                              ? 'Please enter a license plate number'
                              : null,
                          onChanged: (val) =>
                              setState(() => _currentLicense = val),
                        ),
                        const SizedBox(height: 20.0),
                        TextFormField(
                          initialValue: data.keys
                                  .toList()
                                  .toString()
                                  .contains(widget.index.toString())
                              ? userData[widget.index.toString()]
                                  ['bluetooth_id']
                              : '',
                          decoration: const InputDecoration(
                            labelText: "Bluetooth ID",
                            fillColor: Colors.white,
                            hintText: 'Enter your bluetooth ID',
                          ),
                          validator: (val) => val!.isEmpty
                              ? 'Please enter a bluetooth ID'
                              : null,
                          onChanged: (val) => setState(() => _currentBLE = val),
                        ),
                        const SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: const Color(0xff4B667A),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  await DatabaseService(uid: user?.uid)
                                      .updateUserData(
                                    widget.index,
                                    _currentBLE ??
                                        userData[widget.index.toString()]
                                            ['bluetooth_id'],
                                    _currentName ??
                                        userData[widget.index.toString()]
                                            ['name'],
                                    _currentLicense ??
                                        userData[widget.index.toString()]
                                            ['license_plate'],
                                  );
                                  print(_currentBLE);
                                  print(_currentName);
                                  print(_currentLicense);
                                  // ignore: use_build_context_synchronously
                                  Navigator.pop(context);
                                }
                              },
                              child: const Text('Update',
                                  style: TextStyle(color: Colors.white)),
                            ),
                            const SizedBox(width: 80),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: const Color(0xffB62D2D),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  await DatabaseService(uid: user?.uid)
                                      .deleteUserData(widget.index);
                                  // ignore: use_build_context_synchronously
                                  Navigator.pop(context);
                                }
                              },
                              child: const Text('Delete',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
            return const Loading();
          }
        });
  }
}
