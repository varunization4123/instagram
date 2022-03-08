// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram/models/user.dart';
import 'package:instagram/providers/user_provider.dart';
import 'package:instagram/resources/firestore_methods.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/utils/utils.dart';
import 'package:instagram/widgets/comment_card.dart';
import 'package:provider/provider.dart';

class CommentScreen extends StatefulWidget {
  final String postId;
  final String user;
  final String description;
  final String username;
  const CommentScreen({
    Key? key,
    required this.postId,
    required this.user,
    required this.description,
    required this.username,
  }) : super(key: key);

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController _commentController = TextEditingController();

  void createComment({
    required String username,
    required String uid,
    required String postId,
    required String profileImage,
  }) async {
    try {
      String res = await FirestoreMethods().commentOnPost(
        _commentController.text,
        uid,
        postId,
        username,
        profileImage,
        [],
      );

      _commentController.clear();

      if (res != 'success') {
        showSnackBar(content: 'something went wrong', context: context);
      }
    } catch (e) {
      showSnackBar(content: e.toString(), context: context);
      print(e);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: primaryColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // post description
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(widget.user),
                            radius: 20,
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: RichText(
                                text: TextSpan(
                                    style: const TextStyle(color: primaryColor),
                                    children: [
                                      TextSpan(
                                        text: widget.username,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const TextSpan(text: '  '),
                                      TextSpan(
                                        text: widget.description,
                                      ),
                                    ]),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            const Text(
                              '2h',
                              style: TextStyle(
                                  color: secondaryColor, fontSize: 14),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    color: secondaryColor,
                    thickness: 0.1,
                  )
                ],
              ),
            ),
            // Comments
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .doc(widget.postId)
                  .collection('comments')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(
                    color: primaryColor,
                  );
                }
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) => CommentCard(
                          snap: snapshot.data!.docs[index].data(),
                        ));
              },
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        color: Colors.grey.shade900,
        padding: const EdgeInsets.all(15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: CircleAvatar(
                backgroundImage: NetworkImage(user!.photoUrl),
                radius: 15,
              ),
            ),
            Expanded(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
                child: TextField(
                  controller: _commentController,
                  maxLines: 8,
                  decoration: const InputDecoration(
                      hintText: 'Write a comment..', border: InputBorder.none),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                createComment(
                    username: user.username,
                    uid: user.uid,
                    postId: widget.postId,
                    profileImage: user.photoUrl);
              },
              child: const Text('Post'),
            ),
          ],
        ),
      ),
    );
  }
}
