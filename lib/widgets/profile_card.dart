import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram/models/user.dart';
import 'package:instagram/providers/user_provider.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/widgets/search_card.dart';
import 'package:provider/provider.dart';

class ProfileCard extends StatefulWidget {
  String uid;
  String? presentUser;
  bool isNotPrimaryUser;
  ProfileCard({Key? key, required this.uid, required this.isNotPrimaryUser})
      : super(key: key);

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  bool isFollowing = false;
  late final String username;
  late final String name;
  late final String bio;
  late final String photoUrl;
  late int followers;
  late List followersList = [];
  late final int following;
  Map<String, dynamic> userData = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    try {
      print(widget.uid);
      var snap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      username = snap.data()!['username'];
      name = snap.data()!['name'];
      bio = snap.data()!['bio'];
      photoUrl = snap.data()!['photoUrl'];
      followersList = snap.data()!['followers'];
      followers = followersList.length;
      List followingList = snap.data()!['following'];
      following = followingList.length;
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void checkIfFollowing() async {
    for (var follower in followersList) {
      if (follower == widget.presentUser) {
        setState(() {
          isFollowing = true;
        });
      } else {
        setState(() {
          isFollowing = false;
        });
      }
    }
  }

  Future<String> addAsFollower() async {
    String result = "Something went wrong";
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .update({
        'followers': FieldValue.arrayUnion([widget.presentUser])
      });

      followers--;
      result = 'Success';
    } catch (e) {
      result = e.toString();
      print(e.toString());
    }
    return result;
  }

  Future<String> removeAsFollower() async {
    String result = "Something went wrong";
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .update({
        'followers': FieldValue.arrayRemove([widget.presentUser])
      });
      followers--;

      result = 'Success';
    } catch (e) {
      result = e.toString();
      print(e.toString());
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    widget.presentUser = FirebaseAuth.instance.currentUser!.uid;
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              // leading: const Icon(Icons.arrow_back_ios_new_rounded),
              backgroundColor: mobileBackgroundColor,
              title: Text(username),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundImage: NetworkImage(photoUrl),
                            ),
                            const SizedBox(width: 20.0),
                            const UserData(
                              numberOfItems: '0',
                              item: 'Posts',
                            ),
                            UserData(
                              numberOfItems: '$followers',
                              item: 'Followers',
                            ),
                            UserData(
                              numberOfItems: '$following',
                              item: 'Following',
                            ),
                          ],
                        ),
                        const Divider(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(name),
                            ),
                            Text(bio),
                          ],
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        widget.isNotPrimaryUser
                            ? isFollowing
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: OutlinedButton(
                                          onPressed: () {
                                            removeAsFollower();
                                          },
                                          child: const Text(
                                            'Following',
                                            style:
                                                TextStyle(color: primaryColor),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5.0,
                                      ),
                                      Expanded(
                                        child: OutlinedButton(
                                          onPressed: () {},
                                          child: const Text(
                                            'Message',
                                            style:
                                                TextStyle(color: primaryColor),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            addAsFollower();
                                          },
                                          child: const Text('Follow'),
                                        ),
                                      ),
                                    ],
                                  )
                            : Column(
                                children: [
                                  OutlinedButton(
                                      onPressed: () {},
                                      child: const Text('Edit Profile')),
                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                  Row(
                                    children: [
                                      OutlinedButton(
                                          onPressed: () {},
                                          child: const Text('Insights')),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      OutlinedButton(
                                          onPressed: () {},
                                          child: const Text('Contacts')),
                                    ],
                                  )
                                ],
                              )
                      ],
                    ),
                  ),
                  FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('posts')
                          .where('uid', isEqualTo: widget.uid)
                          .get(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        return GridView.builder(
                          shrinkWrap: true,
                          itemCount: (snapshot.data! as dynamic).docs.length,
                          itemBuilder: (context, index) => SearchCard(
                            snap:
                                (snapshot.data! as dynamic).docs[index].data(),
                          ),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 0.1,
                            crossAxisSpacing: 0.1,
                          ),
                        );
                      })
                ],
              ),
            ),
          );
  }
}

class UserData extends StatelessWidget {
  final String numberOfItems;
  final String item;
  const UserData({
    Key? key,
    required this.numberOfItems,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              numberOfItems,
              style: const TextStyle(fontSize: 24),
            ),
          ),
          Text(
            item,
            style: const TextStyle(fontSize: 12),
          ),
        ]);
  }
}
