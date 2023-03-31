import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:parking_app/models/reserve.dart';
import 'package:parking_app/models/verification.dart';
import 'package:parking_app/models/user.dart';
import 'package:parking_app/screens/reservation/reserve_list.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:parking_app/services/auth.dart';
import 'package:parking_app/services/database.dart';

class Reservation extends StatefulWidget {
  const Reservation({Key? key}) : super(key: key);

  @override
  State<Reservation> createState() => _ReservationState();
}

class _ReservationState extends State<Reservation> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserParam?>(context);

    return StreamProvider<List<String>?>.value(
      value: DatabaseService().reserve,
      initialData: null,
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        appBar: AppBar(
          backgroundColor: Color(0xff4B667A),
          elevation: 0.0,
          title: Text('Reservation'),
        ),
        body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/parking_lot_test.jpg'),
                fit: BoxFit.fitHeight,
              ),
            ),
            child: ReserveList()),
      ),
    );
  }
}
