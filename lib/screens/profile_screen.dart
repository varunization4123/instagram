import 'package:flutter/material.dart';
import 'package:instagram/widgets/profile_card.dart';

class ProfileScreen extends StatelessWidget {
  String uid;
  ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProfileCard(
      uid: uid,
      isNotPrimaryUser: false,
    );
  }
}
