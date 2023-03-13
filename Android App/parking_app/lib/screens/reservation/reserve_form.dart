import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parking_app/models/user.dart';
import 'package:parking_app/services/database.dart';
import 'package:parking_app/shared/constants.dart';
import 'package:parking_app/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class ReserveForm extends StatefulWidget {
  // final int? index;
  final String? doc_id;

  const ReserveForm({Key? key, this.doc_id}) : super(key: key);

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
    final doc_id = widget.doc_id;

    return StreamBuilder<DocumentSnapshot>(
      stream: DatabaseService(uid: doc_id).reserveData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          DocumentSnapshot<Object?>? reserveData = snapshot.data;
          List<dynamic> reservations =
              (reserveData?.data() as Map<String, dynamic>)['reservations'] ??
                  [];
          List<String> reservedDates = reservations
              .map<String>((reservation) => reservation['duration'].toString())
              .toList();

          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: Padding(
              padding: EdgeInsets.only(bottom: bottom),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                          isSameDay(day, selected_day) &&
                          !reservedDates
                              .contains(DateFormat('yyyy-MM-dd').format(day)),
                      focusedDay: selected_day,
                      firstDay: today,
                      lastDay: today.add(Duration(days: 90)),
                      onDaySelected: _onDaySelected,
                      calendarStyle: const CalendarStyle(
                        selectedDecoration: BoxDecoration(
                          color: Color.fromARGB(255, 22, 126, 121),
                          shape: BoxShape.rectangle,
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(120, 0, 0, 0),
                              blurRadius: 5.0,
                              spreadRadius: 1.0,
                              offset: Offset(4.0, 4.0),
                            ),
                          ],
                        ),
                        selectedTextStyle: TextStyle(color: Colors.white),
                        todayDecoration: BoxDecoration(
                          color: Color.fromARGB(132, 22, 126, 121),
                          shape: BoxShape.rectangle,
                        ),
                        todayTextStyle: TextStyle(color: Colors.white),
                      ),
                      calendarBuilders: CalendarBuilders(
                        defaultBuilder: (context, day, focusedDay) {
                          for (String reservedDate in reservedDates) {
                            DateTime d = DateTime.parse(reservedDate);
                            if (day.day == d.day &&
                                day.month == d.month &&
                                day.year == d.year) {
                              return Container(
                                margin: const EdgeInsets.all(6.0),
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 153, 11, 11),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color.fromARGB(120, 0, 0, 0),
                                      blurRadius: 5.0,
                                      spreadRadius: 1.0,
                                      offset: Offset(4.0, 4.0),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    '${day.day}',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              );
                            }
                          }
                          if (!reservedDates
                              .contains(DateFormat('yyyy-MM-dd').format(day))) {
                            return null;
                          }
                          return Container(
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '${day.day}',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      child: Text('Reserve',
                          style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(255, 22, 126, 121),
                        minimumSize: Size(200, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await DatabaseService(uid: doc_id).updateReserveData(
                            selected_day.toString().split(" ")[0],
                            'Reserved',
                            user?.uid.toString() ?? '',
                          );
                          Navigator.pop(context);
                        }
                      },
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Loading();
        }
      },
    );
  }
}
