import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram/screens/activity_screen.dart';
import 'package:instagram/screens/add_post_screen.dart';
import 'package:instagram/screens/home_screen.dart';
import 'package:instagram/screens/profile_screen.dart';
import 'package:instagram/screens/search_screen.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  const HomeScreen(),
  const SearchScreen(),
  const AddPostScreen(),
  // const ActivityScreen(),
  const Page(page: 'Activity'),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
    isNotPrimaryUser: false,
  ),
];

class Page extends StatelessWidget {
  final String page;
  const Page({
    Key? key,
    required this.page,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(page),
    );
  }
}
