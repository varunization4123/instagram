import 'package:flutter/material.dart';
import 'package:instagram/screens/post_screen.dart';

class SearchCard extends StatefulWidget {
  final snap;
  const SearchCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<SearchCard> createState() => _SearchCardState();
}

class _SearchCardState extends State<SearchCard> {
  @override
  Widget build(BuildContext context) {
    final String postUrl = widget.snap['postUrl'];
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostScreen(
              snap: widget.snap,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: SizedBox(
          child: AspectRatio(
            aspectRatio: 1 / 1,
            child: Image(
              fit: BoxFit.cover,
              image: NetworkImage(postUrl),
            ),
          ),
        ),
      ),
    );
  }
}
