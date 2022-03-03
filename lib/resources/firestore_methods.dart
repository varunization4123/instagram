// ignore_for_file: avoid_print

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram/models/post.dart';
import 'package:instagram/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(
    Uint8List img,
    String description,
    String uid,
    String username,
    String profileImage,
    likes,
  ) async {
    String res = "Something went wrong";
    try {
      String postUrl =
          await StorageMethods().uploadImageToStorage('postPic', img, true);

      String postId = const Uuid().v1();

      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: postUrl,
        profileImage: profileImage,
        likes: [],
      );

      _firestore.collection('posts').doc(postId).set(post.toJason());

      res = 'sucess';
    } catch (e) {
      res = e.toString();
      print(e);
    }

    return res;
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
