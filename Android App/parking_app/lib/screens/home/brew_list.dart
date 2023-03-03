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

    return ListView.builder(
      itemCount: info?.length ?? 0,
      itemBuilder: (context, index) {
        // print(index);
        return BrewTile(verification: info![index], index: index + 1);
      },
    );
  }
}
