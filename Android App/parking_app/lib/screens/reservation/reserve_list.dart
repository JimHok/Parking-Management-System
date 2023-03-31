import 'package:parking_app/models/reserve.dart';
import 'package:parking_app/models/reserve.dart';
import 'package:parking_app/screens/reservation/reserve_tile.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class ReserveList extends StatefulWidget {
  const ReserveList({Key? key}) : super(key: key);

  @override
  State<ReserveList> createState() => _ReserveListState();
}

class _ReserveListState extends State<ReserveList> {
  @override
  Widget build(BuildContext context) {
    final reserve = Provider.of<List<String>?>(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(35, 40, 40, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            ' Reserve a Parking Lot',
            style: TextStyle(
              color: Color.fromARGB(255, 0, 0, 0),
              fontSize: 26.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 127.0),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 90.0,
                mainAxisSpacing: 0,
                childAspectRatio: 1.47,
              ),
              itemCount: reserve?.length ?? 0,
              itemBuilder: (context, index) {
                return ReserveTile(doc_id: reserve![index], index: index + 1);
              },
            ),
          ),
        ],
      ),
    );
  }
}
