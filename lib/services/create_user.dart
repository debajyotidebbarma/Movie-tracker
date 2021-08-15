import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<void> createUser(String displayName, BuildContext context) async {
  CollectionReference userCollectionReference =
      FirebaseFirestore.instance.collection('users');
  FirebaseAuth auth = FirebaseAuth.instance;
  String uid = auth.currentUser!.uid;
  // print(auth.currentUser);

  Map<String, dynamic> user = {
    'avatar_url': '',
    'display_name': displayName,
    'profession': 'student',
    'quote': 'Life is great',
    'uid': uid
  };
  // print('working');
  // print(uid);
  userCollectionReference.add(user);
}
