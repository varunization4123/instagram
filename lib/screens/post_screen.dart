import 'package:flutter/material.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/widgets/comment_card.dart';
import 'package:instagram/widgets/post_card.dart';

class PostScreen extends StatefulWidget {
  final snap;
  const PostScreen({Key? key, required this.snap}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        leading: InkWell(
          onTap: (() => Navigator.pop(context)),
          child: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: ListView(children: [
        PostCard(snap: widget.snap),
      ]),
    );
  }
}
