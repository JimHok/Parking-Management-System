import 'dart:ui';

import 'package:parking_app/models/reserve.dart';
import 'package:flutter/material.dart';
import 'package:parking_app/screens/reservation/reserve_form.dart';

class ReserveTile extends StatelessWidget {
  final String? doc_id;
  final int? index;
  ReserveTile({this.doc_id, this.index});

  @override
  Widget build(BuildContext context) {
    void _showReservePanel(doc_id) {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return FractionallySizedBox(
                heightFactor: 0.75,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                  child: ReserveForm(doc_id: doc_id),
                ));
          },
          isScrollControlled: true);
    }

    return Padding(
      padding: EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () => _showReservePanel(doc_id),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            // color: Color.fromARGB(64, 114, 114, 114),
            // border: Border.all(
            //   color: Color.fromARGB(255, 114, 114, 114),
            //   width: 2.0,
            // ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  'P${index.toString().padLeft(3, '0')}',
                  style: const TextStyle(
                      color: Color.fromARGB(255, 92, 92, 92),
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10.0),
              const Center(
                child: Text(
                  'Available',
                  style: TextStyle(
                      color: Color.fromARGB(255, 41, 175, 15),
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
