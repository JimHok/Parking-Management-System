import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parking_app/models/verification.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  // collection reference
  final CollectionReference brewCollection =
      FirebaseFirestore.instance.collection('brews');

  Future updateUserData(String bluetooth_id, String name, String license_plate) async {
    return await brewCollection.doc(uid).set({
      'bluetooth_id': bluetooth_id,
      'name': name,
      'license_plate': license_plate,
    });
  }

  // brew list from snapshot
  List<Information> _brewListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Information(
        name: doc.get('name') ?? '',
        bluetooth_id: doc.get('bluetooth_id') ?? '0',
        license_plate: doc.get('license_plate') ?? '0',
      );
    }).toList();
  }

  // get brews stream
  Stream<List<Information>> get brews {
    return brewCollection.snapshots().map(_brewListFromSnapshot);
  }

  // get user doc stream
  Stream<DocumentSnapshot> get userData {
    return brewCollection.doc(uid).snapshots();
  }
}
