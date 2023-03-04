import 'package:parking_app/models/verification.dart';
import 'package:parking_app/screens/home/brew_tile.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:parking_app/models/user.dart';
import 'package:parking_app/services/database.dart';

class BrewList extends StatefulWidget {
  const BrewList({Key? key}) : super(key: key);

  @override
  State<BrewList> createState() => _BrewListState();
}

class _BrewListState extends State<BrewList> {
  @override
  Widget build(BuildContext context) {
    final info = Provider.of<List<Information>?>(context);
    final user = Provider.of<UserParam?>(context);

    var stream = DatabaseService(uid: user?.uid).userData;

    return FutureBuilder<DocumentSnapshot>(
      future: stream.first,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData) {
          return Text('No data found');
        }

        var infoList = snapshot.data!.data() as Map<String, dynamic>;
        var infokey = infoList.keys.toList();

        return ListView.builder(
          itemCount: info?.length ?? 0,
          itemBuilder: (context, index) {
            return BrewTile(
                verification: info![index], index: int.parse(infokey[index]));
          },
        );
      },
    );
  }
}
