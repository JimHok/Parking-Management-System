import 'package:cloud_firestore/cloud_firestore.dart';

class Reserve {
  final String? duration;
  final String? status;
  final String? uid;

  Reserve({this.duration, this.status, this.uid});
}
