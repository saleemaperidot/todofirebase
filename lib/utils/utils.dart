import 'package:cloud_firestore/cloud_firestore.dart';

CollectionReference<Map<String, dynamic>> firebasecollection =
    FirebaseFirestore.instance.collection('users');
