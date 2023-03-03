import 'package:parking_app/models/verification.dart';
import 'package:flutter/material.dart';
import 'package:parking_app/screens/home/setting_form.dart';

class BrewTile extends StatelessWidget {
  final Information? verification;
  var index;

  BrewTile({this.verification, this.index});

  @override
  Widget build(BuildContext context) {
    void _showSettingsPanel() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
              child: SettingForm(index: index),
            );
          });
    }

    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25.0,
            backgroundImage: AssetImage('assets/car_icon.png'),
          ),
          title: Text(verification!.name!),
          subtitle:
              Text('Licence Plate Number: ${verification!.license_plate}'),
          onTap: () => _showSettingsPanel(),
        ),
      ),
    );
  }
}
