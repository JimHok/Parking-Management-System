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
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        color: Color.fromARGB(255, 73, 100, 116),
        child: ListTile(
          leading: const CircleAvatar(
            radius: 25.0,
            backgroundImage: AssetImage('assets/parking_icon.jpg'),
            backgroundColor: Color.fromARGB(255, 11, 25, 128),
          ),
          title: Text('Parking Lot ${index.toString()}',
              style:
                  const TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
          // subtitle: Text('${reserve!.status}',
          //     style: reserve!.status == 'Reserved'
          //         ? const TextStyle(color: Color.fromARGB(255, 255, 0, 0))
          //         : const TextStyle(color: Color.fromARGB(255, 0, 255, 0))),
          subtitle: Text('Place Holder',
              style:
                  const TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
          onTap: () => _showReservePanel(doc_id),
        ),
      ),
    );
  }
}
