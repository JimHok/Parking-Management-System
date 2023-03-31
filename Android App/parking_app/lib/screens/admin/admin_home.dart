import 'package:flutter/material.dart';
import 'package:parking_app/models/time.dart';
import 'package:parking_app/screens/admin/admin_list.dart';
import 'package:parking_app/services/auth.dart';
import 'package:parking_app/services/database.dart';
import 'package:provider/provider.dart';

class AdminHome extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Time>>.value(
        value: DatabaseService().time,
        initialData: List<Time>.empty(),
        child: Scaffold(
          backgroundColor: Color(0xff7AA5C5),
          appBar: AppBar(
            backgroundColor: Color(0xff4B667A),
            elevation: 0.0,
            title: const Text('Admin Home'),
            actions: <Widget>[
              TextButton.icon(
                icon: const Icon(Icons.account_circle_outlined),
                label: const Text('Logout'),
                onPressed: () async {
                  await _auth.signOut();
                },
                style: TextButton.styleFrom(
                  primary: Colors.white,
                ),
              ),
            ],
          ),
          body: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/car_bg.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: const AdminList()),
        ));
  }
}
