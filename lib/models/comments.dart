import 'package:cloud_firestore/cloud_firestore.dart';

class Comments {
  final String comment;
  final String uid;
  final String username;
  final DateTime datePublished;
  final String profileImage;
  final likes;

  Comments({
    required this.comment,
    required this.uid,
    required this.username,
    required this.datePublished,
    required this.profileImage,
    required this.likes,
  });

  Map<String, dynamic> toJason() => {
        'username': username,
        'uid': uid,
        'comment': comment,
        'datePublished': datePublished,
        'profileImage': profileImage,
        'likes': likes,
      };

  static Comments fromSnap(DocumentSnapshot snap) {
    var snapshot = (snap.data() as Map<String, dynamic>);
    return Comments(
      username: snapshot['username'],
      uid: snapshot['uid'],
      comment: snapshot['comment'],
      datePublished: snapshot['datePublished'],
      profileImage: snapshot['profileImage'],
      likes: snapshot['likes'],
    );
  }
}
