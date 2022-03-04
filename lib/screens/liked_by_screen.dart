// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/widgets/liked_by_card.dart';

class LikedBy extends StatelessWidget {
  final username;
  final photoUrl;
  final name;
  const LikedBy({
    Key? key,
    required this.username,
    required this.photoUrl,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      appBar: AppBar(
          leading: GestureDetector(
            onTap: (() => Navigator.pop(context)),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: primaryColor,
            ),
          ),
          backgroundColor: mobileBackgroundColor),
      body: LikedByCard(photoUrl: photoUrl, username: username, name: name),
    );
  }
}
