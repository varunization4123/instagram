import 'package:flutter/material.dart';
import 'package:instagram/screens/add_post_screen.dart';
import 'package:instagram/screens/home_screen.dart';

const webScreenSize = 600;

const homeScreenItems = [
  HomeScreen(),
  Page(page: 'Search'),
  AddPostScreen(),
  Page(page: 'Favorites'),
  Page(page: 'Profile'),
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
