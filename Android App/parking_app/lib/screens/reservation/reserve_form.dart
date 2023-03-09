import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parking_app/models/user.dart';
import 'package:parking_app/services/database.dart';
import 'package:parking_app/shared/constants.dart';
import 'package:parking_app/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class ReserveForm extends StatefulWidget {
  const ReserveForm({Key? key}) : super(key: key);

  @override
  State<ReserveForm> createState() => _ReserveFormState();
}

class _ReserveFormState extends State<ReserveForm> {
  final _formKey = GlobalKey<FormState>();

  Timestamp? _currentDuration;
  String? _currentStatus;
  String? _currentUID;

  DateTime today = DateTime.now();

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
              body: Padding(
                padding: EdgeInsets.only(bottom: bottom),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 20.0),
                      Text('Update Your Information',
                          style: TextStyle(fontSize: 20.0)),
                      SizedBox(height: 20.0),
                      // TextFormField(
                      //   initialValue: userData!['duration'],
                      //   decoration: InputDecoration(
                      //     labelText: "Duration",
                      //     fillColor: Colors.white,
                      //     hintText: 'Enter your duration',
                      //   ),
                      //   validator: (val) =>
                      //       val!.isEmpty ? 'Please enter a duration' : null,
                      //   onChanged: (val) => setState(
                      //       () => _currentDuration = val as Timestamp?),
                      // ),
                      TableCalendar(
                        focusedDay: today,
                        firstDay: today,
                        lastDay: today.add(Duration(days: 365)),
                      ),
                      // SizedBox(height: 20),
                      // TextFormField(
                      //   initialValue: userData!['status'],
                      //   decoration: InputDecoration(
                      //     labelText: "Status",
                      //     fillColor: Colors.white,
                      //     hintText: 'Enter your status',
                      //   ),
                      //   validator: (val) =>
                      //       val!.isEmpty ? 'Please enter a status' : null,
                      //   onChanged: (val) => setState(() => _currentUID = val),
                      // ),
                      // SizedBox(height: 20.0),
                      // TextFormField(
                      //   initialValue: userData['uid'],
                      //   decoration: InputDecoration(
                      //     labelText: "UID",
                      //     fillColor: Colors.white,
                      //     hintText: 'Enter your uid',
                      //   ),
                      //   validator: (val) =>
                      //       val!.isEmpty ? 'Please enter a uid' : null,
                      //   onChanged: (val) =>
                      //       setState(() => _currentStatus = val),
                      // ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        child: Text('Update',
                            style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xffB62D2D),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await DatabaseService(uid: user?.uid)
                                .updateReserveData(
                              _currentStatus ?? userData!['uid'],
                              _currentDuration ?? userData!['duration'],
                              _currentUID ?? userData!['status'],
                            );
                            print(_currentStatus);
                            print(_currentDuration);
                            print(_currentUID);
                            Navigator.pop(context);
                          }
                        },
                      )
                    ],
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
