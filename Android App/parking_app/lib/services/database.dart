import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parking_app/models/verification.dart';
import 'package:parking_app/models/reserve.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  // collection reference
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  final CollectionReference reservationCollection =
      FirebaseFirestore.instance.collection('reservation');

  Future setUserData(int index, String bluetooth_id, String name,
      String license_plate, String status) async {
    return await usersCollection.doc(uid).set({
      '$index': {
        'bluetooth_id': bluetooth_id,
        'name': name,
        'license_plate': license_plate,
        'status': status,
      }
    });
  }

  Future updateUserData(int index, String bluetooth_id, String name,
      String license_plate, String status) async {
    return await usersCollection.doc(uid).update({
      '$index': {
        'bluetooth_id': bluetooth_id,
        'name': name,
        'license_plate': license_plate,
        'status': status,
      }
    });
  }

  Future updateReserveData(String duration, String status, String user) async {
    return await reservationCollection.doc(uid).update({
      'reservations': FieldValue.arrayUnion([
        {
          'duration': duration,
          'status': status,
          'uid': user,
        }
      ])
    });
  }

  Future deleteUserData(int index) async {
    return await usersCollection.doc(uid).update({
      '$index': FieldValue.delete(),
    });
  }

  // brew list from snapshot
  List<Information> _usersListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Information(
        name: doc.get('name') ?? '',
        bluetooth_id: doc.get('bluetooth_id') ?? '',
        license_plate: doc.get('license_plate') ?? '',
        status: doc.get('status') ?? '',
      );
    }).toList();
  }

  // info data from snapshot
  List<Information> _getInfoFromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return data.values.map((data) {
      return Information(
        name: data['name'] ?? '',
        bluetooth_id: data['bluetooth_id'] ?? '',
        license_plate: data['license_plate'] ?? '',
        status: data['status'] ?? '',
      );
    }).toList();
  }

  List<String> _reserveListFromSnapshot(QuerySnapshot snapshot) {
    List<String> ids = [];
    snapshot.docs.forEach((doc) {
      ids.add(doc.id);
    });
    return ids;
  }

  // get users stream
  Stream<List<Information>> get users {
    return usersCollection.snapshots().map(_usersListFromSnapshot);
  }

  Stream<List<Information>> get info {
    return usersCollection.doc(uid).snapshots().map(_getInfoFromSnapshot);
  }

  Stream<List<String>> get reserve {
    return reservationCollection.snapshots().map(_reserveListFromSnapshot);
  }

  // get user doc stream
  Stream<DocumentSnapshot> get userData {
    return usersCollection.doc(uid).snapshots();
  }

  // get user doc stream
  Stream<DocumentSnapshot> get reserveData {
    return reservationCollection.doc(uid).snapshots();
  }
}
