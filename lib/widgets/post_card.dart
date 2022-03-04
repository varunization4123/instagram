// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram/models/user.dart';
import 'package:instagram/providers/user_provider.dart';
import 'package:instagram/resources/firestore_methods.dart';
import 'package:instagram/screens/comments_screen.dart';
import 'package:instagram/screens/liked_by_screen.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  final snap;
  final likeIcon = Icon(Icons.favorite, color: Colors.red[900]);

  PostCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  bool smallLikePressed = false;
  bool savePostPressed = false;

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;

    final String profileImage = widget.snap['profileImage'];
    final String username = widget.snap['username'];
    final String uid = widget.snap['uid'];
    final String description = widget.snap['description'];
    final String postUrl = widget.snap['postUrl'];
    final String postId = widget.snap['postId'];
    final Timestamp timestamp = widget.snap['datePublished'];
    final likes = widget.snap['likes'];

    setState(() {
      if (likes.contains(uid)) {
        smallLikePressed = true;
      } else {
        smallLikePressed = false;
      }
    });

    return Padding(
      padding: const EdgeInsets.only(bottom: 40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 8,
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(profileImage),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(username),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.more_vert),
                )
              ],
            ),
          ),

          // Image
          GestureDetector(
            onDoubleTap: () async {
              await FirestoreMethods().likePost(postId, uid, likes);
              setState(() {
                isLikeAnimating = true;
              });
              print('post was clicked');
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  child: AspectRatio(
                    aspectRatio: 4 / 5,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            postUrl,
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isLikeAnimating ? 1 : 0,
                  child: LikeAnimation(
                    child: const Icon(
                      Icons.favorite,
                      color: primaryColor,
                      size: 100,
                    ),
                    isAnimating: isLikeAnimating,
                    duration: const Duration(milliseconds: 400),
                    onEnd: () {
                      setState(() {
                        isLikeAnimating = false;
                        smallLikePressed = true;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          // Icons
          Row(
            children: [
              LikeAnimation(
                isAnimating: likes.contains(user!.uid),
                smallLike: true,
                child: BottomIcon(
                  color: smallLikePressed ? Colors.red.shade900 : primaryColor,
                  icon: smallLikePressed
                      ? (Icons.favorite)
                      : Icons.favorite_border,
                  onTap: (() async {
                    await FirestoreMethods().likePost(postId, uid, likes);
                    setState(() {
                      smallLikePressed = smallLikePressed ? false : true;
                      print('user liked the post');
                    });
                  }),
                ),
              ),
              BottomIcon(
                icon: Icons.chat_bubble_outline,
                onTap: (() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CommentScreen(
                        postId: postId,
                        user: profileImage,
                        description: description,
                        username: username,
                      ),
                    ),
                  );
                }),
              ),
              BottomIcon(
                icon: Icons.send_outlined,
                onTap: (() {}),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: BottomIcon(
                    icon: savePostPressed
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_border_rounded,
                    onTap: (() {
                      setState(() {
                        savePostPressed = true;
                      });
                    }),
                  ),
                ),
              ),
            ],
          ),

          // No. of Likes
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LikedBy(
                            username: username,
                            photoUrl: profileImage,
                            name: user.name,
                          )));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text('${likes.length} likes'),
            ),
          ),

          // Description
          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
            child: RichText(
              text: TextSpan(
                  style: const TextStyle(color: primaryColor),
                  children: [
                    TextSpan(
                      text: username,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const TextSpan(text: '  '),
                    TextSpan(
                      text: description,
                    ),
                  ]),
            ),
          ),

          // Date
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              DateFormat.yMMMd().format(
                timestamp.toDate(),
              ),
              style: const TextStyle(color: secondaryColor),
            ),
          ),
        ],
      ),
    );
  }
}

class BottomIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final void Function()? onTap;
  const BottomIcon(
      {Key? key,
      required this.icon,
      required this.onTap,
      this.color = primaryColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: IconButton(
        onPressed: onTap,
        icon: Icon(
          icon,
          color: color,
        ),
      ),
    );
  }
}
