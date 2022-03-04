import 'package:flutter/material.dart';
import 'package:instagram/utils/colors.dart';

class CommentCard extends StatefulWidget {
  final snap;
  const CommentCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    final String comment = widget.snap['comment'];
    final String profileImage = widget.snap['profileImage'];
    final String username = widget.snap['username'];
    final likes = widget.snap['likes'];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(profileImage),
              radius: 20,
            ),
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: username,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const TextSpan(text: '  '),
                TextSpan(text: comment),
              ],
            ),
          ),
          const Expanded(child: SizedBox()),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Icon(
              Icons.favorite_border,
              size: 16.0,
              color: secondaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
