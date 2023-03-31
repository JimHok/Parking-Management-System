import 'package:parking_app/models/verification.dart';
import 'package:parking_app/models/user.dart';
import 'package:parking_app/screens/home/brew_list.dart';
import 'package:parking_app/screens/home/setting_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parking_app/shared/loading.dart';
import 'package:parking_app/screens/reservation/reservation.dart';
import 'package:parking_app/screens/admin/admin_home.dart';

import 'package:parking_app/services/auth.dart';
import 'package:parking_app/services/database.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserParam?>(context);

    void _showSettingsPanel(Index) {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
              child: SettingForm(
                index: Index,
              ),
            );
          });
    }

    Future<bool> isAdmin(String email) async {
      final adminSnapshot = await FirebaseFirestore.instance
          .collection('admin')
          .doc('admin_account')
          .get();
      List<String> adminAccounts = [adminSnapshot.get('account')];
      return adminAccounts.contains(email);
    }

    return FutureBuilder<bool>(
        future: isAdmin(user?.uid ?? ''),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!) {
            // User is admin, navigate to admin home page
            return AdminHome();
          } else {
            // User is not admin, navigate to normal home page
            return StreamProvider<List<Information>>.value(
              value: DatabaseService(uid: user?.uid).info,
              initialData: List<Information>.empty(),
              child: Scaffold(
                backgroundColor: Color(0xff7AA5C5),
                appBar: AppBar(
                  backgroundColor: Color(0xff4B667A),
                  elevation: 0.0,
                  title: const Text('Registration'),
                  actions: <Widget>[
                    TextButton.icon(
                      icon: Icon(Icons.car_rental),
                      label: Text('Reserve'),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Reservation()));
                      },
                      style: TextButton.styleFrom(
                        primary: Colors.white,
                      ),
                    ),
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
                    child: const BrewList()),
                floatingActionButton: FloatingActionButton(
                  onPressed: () async {
                    var stream = DatabaseService(uid: user?.uid).userData;
                    var snapshot = await stream.first;
                    var infoList = snapshot.data() as Map<String, dynamic>;
                    var infoListKeys = infoList.keys.toList();
                    var max = infoListKeys.map(int.parse).toList().reduce(
                        (value, element) => value > element ? value : element);
                    _showSettingsPanel(max + 1);
                  },
                  backgroundColor: const Color(0xff4B667A),
                  child: const Icon(Icons.add),
                ),
              ),
            );
          }
        });
  }
}
