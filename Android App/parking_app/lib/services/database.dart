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

  Future updateReserveData(
      Timestamp duration, String status, String uid) async {
    return await usersCollection.doc(uid).update({
      'duration': duration,
      'status': status,
      'uid': uid,
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

  List<Reserve> _reserveListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Reserve(
        duration: doc.get('duration') ?? 1638592424384,
        status: doc.get('status') ?? '',
        uid: doc.get('uid') ?? '',
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

  // get users stream
  Stream<List<Information>> get users {
    return usersCollection.snapshots().map(_usersListFromSnapshot);
  }

  Stream<List<Reserve>> get reserve {
    return reservationCollection.snapshots().map(_reserveListFromSnapshot);
  }

  Stream<List<Information>> get info {
    return usersCollection.doc(uid).snapshots().map(_getInfoFromSnapshot);
  }

  // get user doc stream
  Stream<DocumentSnapshot> get userData {
    return usersCollection.doc(uid).snapshots();
  }
}
