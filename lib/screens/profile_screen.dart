import 'package:flutter/material.dart';
import 'package:instagram/widgets/profile_card.dart';

class ProfileScreen extends StatelessWidget {
  String uid;
  bool isNotPrimaryUser;
  ProfileScreen({Key? key, required this.uid, required this.isNotPrimaryUser})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(uid);
    return ProfileCard(
      uid: uid,
      isNotPrimaryUser: isNotPrimaryUser,
    );
  }
}
