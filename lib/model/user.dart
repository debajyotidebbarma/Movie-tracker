import 'package:cloud_firestore/cloud_firestore.dart';

class MUser {
  final String avatarUrl;
  final String id;
  final String uid;
  final String displayName;
  final String quote;
  final String profession;

  MUser(
      {required this.avatarUrl,
      required this.id,
      required this.uid,
      required this.displayName,
      required this.quote,
      required this.profession});

  factory MUser.fromDocument(QueryDocumentSnapshot data) {
    // print(data);
    // print(data.get('display_name'));
    // print(data.get('profession'));

    return MUser(
        avatarUrl: data.get('avatar_url'),
        id: data.id,
        uid: data.get('uid'),
        displayName: data.get('display_name'),
        quote: data.get('quote'),
        profession: data.get('profession'));
  }

  Map<String, dynamic> toMap() {
    // print(displayName);
    return {
      'uid': uid,
      'display_name': displayName,
      'avatar_url': avatarUrl,
      'quote': quote,
      'profession': profession
    };
  }
}
