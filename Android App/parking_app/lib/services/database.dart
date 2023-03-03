import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parking_app/models/verification.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  // collection reference
  final CollectionReference brewCollection =
      FirebaseFirestore.instance.collection('brews');

  Future setUserData(
      int index, String bluetooth_id, String name, String license_plate) async {
    return await brewCollection.doc(uid).set({
      '$index': {
        'bluetooth_id': bluetooth_id,
        'name': name,
        'license_plate': license_plate,
      }
    });
  }

  Future updateUserData(
      int index, String bluetooth_id, String name, String license_plate) async {
    return await brewCollection.doc(uid).update({
      '$index': {
        'bluetooth_id': bluetooth_id,
        'name': name,
        'license_plate': license_plate,
      }
    });
  }

  // brew list from snapshot
  List<Information> _brewListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Information(
        name: doc.get('name') ?? '',
        bluetooth_id: doc.get('bluetooth_id') ?? '',
        license_plate: doc.get('license_plate') ?? '',
      );
    }).toList();
  }

  // brew data from snapshot
  List<Information> _getInfoFromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return data.values.map((data) {
      return Information(
        name: data['name'] ?? '',
        bluetooth_id: data['bluetooth_id'] ?? '',
        license_plate: data['license_plate'] ?? '',
      );
    }).toList();
  }

  // get brews stream
  Stream<List<Information>> get brews {
    return brewCollection.snapshots().map(_brewListFromSnapshot);
  }

  Stream<List<Information>> get info {
    return brewCollection.doc(uid).snapshots().map(_getInfoFromSnapshot);
  }

  // get user doc stream
  Stream<DocumentSnapshot> get userData {
    return brewCollection.doc(uid).snapshots();
  }
}
