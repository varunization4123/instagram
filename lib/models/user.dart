import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uid;
  final String password;
  final String username;
  final String name;
  final String photoUrl;
  final String bio;
  final List followers;
  final List following;

  User({
    required this.email,
    required this.uid,
    required this.password,
    required this.username,
    required this.name,
    required this.photoUrl,
    required this.bio,
    required this.followers,
    required this.following,
  });

  Map<String, dynamic> toJason() => {
        'username': username,
        'name': name,
        'uid': uid,
        'email': email,
        'password': password,
        'bio': bio,
        'photoUrl': photoUrl,
        'followers': followers,
        'following': following,
      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = (snap.data() as Map<String, dynamic>);
    return User(
      email: snapshot['email'],
      uid: snapshot['uid'],
      password: snapshot['password'],
      username: snapshot['username'],
      name: snapshot['name'],
      photoUrl: snapshot['photoUrl'],
      bio: snapshot['bio'],
      followers: snapshot['followers'],
      following: snapshot['following'],
    );
  }
}
