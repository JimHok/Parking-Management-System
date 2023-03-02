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
    final info = Provider.of<Information>(context);

    return ListView.builder(
      itemCount: 1,
      itemBuilder: (context, index) {
        // print(info?[index].name);
        return BrewTile(verification: info);
      },
    );
  }
}
