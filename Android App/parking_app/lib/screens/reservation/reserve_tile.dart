import 'package:parking_app/models/reserve.dart';
import 'package:flutter/material.dart';
import 'package:parking_app/screens/reservation/reserve_form.dart';

class ReserveTile extends StatelessWidget {
  final Reserve? reserve;
  final int? index;
  ReserveTile({this.reserve, this.index});

  @override
  Widget build(BuildContext context) {
    DateTime? date = reserve!.duration;
    void _showReservePanel(index) {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return FractionallySizedBox(
                heightFactor: 0.75,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                  child: ReserveForm(index: index),
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
            backgroundImage: AssetImage('assets/parking_icon.jpg'),
            backgroundColor: Color.fromARGB(255, 11, 25, 128),
          ),
          title: Text('Reserved Date: ${date.toString().split(" ")[0]}',
              style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
          subtitle: Text('${reserve!.status}',
              style: reserve!.status == 'Reserved'
                  ? TextStyle(color: Color.fromARGB(255, 255, 0, 0))
                  : TextStyle(color: Color.fromARGB(255, 0, 255, 0))),
          onTap: () =>
              reserve!.status == 'Reserved' ? '' : _showReservePanel(index),
        ),
      ),
    );
  }
}
