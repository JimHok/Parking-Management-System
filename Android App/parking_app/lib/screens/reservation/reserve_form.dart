import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parking_app/models/user.dart';
import 'package:parking_app/services/database.dart';
import 'package:parking_app/shared/constants.dart';
import 'package:parking_app/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class ReserveForm extends StatefulWidget {
  final int? index;

  const ReserveForm({Key? key, this.index}) : super(key: key);

  @override
  State<ReserveForm> createState() => _ReserveFormState();
}

class _ReserveFormState extends State<ReserveForm> {
  final _formKey = GlobalKey<FormState>();

  DateTime selected_day = DateTime.now();
  DateTime today = DateTime.now();

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      selected_day = day;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserParam?>(context);
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    final index = widget.index;

    return StreamBuilder<DocumentSnapshot>(
        stream: DatabaseService(uid: index.toString()).reserveData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            DocumentSnapshot<Object?>? reserveData = snapshot.data;
            print(index.toString());
            print(selected_day);
            print(user?.uid);
            print(reserveData?.data() as Map<String, dynamic>);
            return Scaffold(
              resizeToAvoidBottomInset: false,
              body: Padding(
                padding: EdgeInsets.only(bottom: bottom),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      SizedBox(height: 20.0),
                      Text('Reserve a Parking Spot',
                          style: TextStyle(fontSize: 25.0)),
                      TableCalendar(
                        headerStyle: const HeaderStyle(
                          formatButtonVisible: false,
                          titleCentered: true,
                          titleTextStyle: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        selectedDayPredicate: (day) =>
                            isSameDay(day, selected_day),
                        focusedDay: selected_day,
                        firstDay: today,
                        lastDay: today.add(Duration(days: 90)),
                        onDaySelected: _onDaySelected,
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        child: Text('Reserve',
                            style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xffB62D2D),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await DatabaseService(uid: index.toString())
                                .updateReserveData(
                              selected_day,
                              'Reserved',
                              user?.uid.toString() ?? '',
                            );
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
