import 'package:parking_app/models/reserve.dart';
import 'package:flutter/material.dart';
import 'package:parking_app/screens/reservation/reserve_form.dart';

class ReserveTile extends StatelessWidget {
  final Reserve? reserve;
  ReserveTile({this.reserve});

  @override
  Widget build(BuildContext context) {
    void _showReservePanel() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return FractionallySizedBox(
                heightFactor: 0.65,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
                  child: ReserveForm(),
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
          leading: CircleAvatar(
            radius: 25.0,
            backgroundImage: AssetImage('assets/parking_icon.png'),
          ),
          title: Text('Reserved Name: ${reserve!.uid!}',
              style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
          subtitle: Text('Parking Lot: ${reserve!.status}',
              style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
          onTap: () => _showReservePanel(),
        ),
      ),
    );
  }
}
