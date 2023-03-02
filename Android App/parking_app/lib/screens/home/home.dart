import 'package:parking_app/models/verification.dart';
import 'package:parking_app/models/user.dart';
import 'package:parking_app/screens/home/brew_list.dart';
import 'package:parking_app/screens/home/setting_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parking_app/shared/loading.dart';

import 'package:parking_app/services/auth.dart';
import 'package:parking_app/services/database.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserParam?>(context);

    void _showSettingsPanel() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
              child: SettingForm(),
            );
          });
    }

    return StreamProvider<Information>.value(
      value: DatabaseService(uid: user?.uid).info,
      initialData: Information(
        name: '',
        bluetooth_id: '',
        license_plate: '',
      ),
      child: Scaffold(
        backgroundColor: Color(0xff7AA5C5),
        appBar: AppBar(
          backgroundColor: Color(0xff4B667A),
          elevation: 0.0,
          title: Text('Registration'),
          actions: <Widget>[
            TextButton.icon(
              icon: Icon(Icons.person),
              label: Text('Logout'),
              onPressed: () async {
                await _auth.signOut();
              },
              style: TextButton.styleFrom(
                primary: Colors.white,
              ),
            ),
            TextButton.icon(
              icon: Icon(Icons.settings),
              label: Text('Settings'),
              onPressed: () => _showSettingsPanel(),
              style: TextButton.styleFrom(
                primary: Colors.white,
              ),
            )
          ],
        ),
        body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/car_bg.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: BrewList()),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Add your onPressed code here!
          },
          backgroundColor: Color(0xff4B667A),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
