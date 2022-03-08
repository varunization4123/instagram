import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram/screens/home_screen.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/widgets/post_card.dart';
import 'package:instagram/widgets/profile_card.dart';

class WebScreenlayout extends StatefulWidget {
  const WebScreenlayout({Key? key}) : super(key: key);

  @override
  State<WebScreenlayout> createState() => _WebScreenlayoutState();
}

class _WebScreenlayoutState extends State<WebScreenlayout> {
  final TextEditingController _searchController = TextEditingController();
  int _page = 0;
  bool isSearching = false;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
    _searchController.dispose();
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  void changePage(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: mobileBackgroundColor,
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 4),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          leadingWidth: 100,
          leading: SvgPicture.asset(
            'assets/images/ic_instagram.svg',
            color: primaryColor,
            height: 100,
          ),
          title: Padding(
            padding: const EdgeInsets.all(120.0),
            child: TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10)),
                label: Row(
                  children: const [
                    Icon(
                      Icons.search,
                      size: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.0),
                      child: Text('Search', style: TextStyle(fontSize: 14)),
                    ),
                  ],
                ),
                filled: true,
                fillColor: textFieldColor,
              ),
              controller: _searchController,
              onFieldSubmitted: (String data) {
                setState(() {
                  isSearching = true;
                });
                print(data);
              },
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    iconSize: 20,
                    onPressed: () {},
                    icon: const Icon(Icons.home_filled),
                  ),
                  IconButton(
                    iconSize: 20,
                    onPressed: () {},
                    icon: const Icon(Icons.messenger_outline_rounded),
                  ),
                  IconButton(
                    iconSize: 20,
                    onPressed: () {},
                    icon: const Icon(Icons.add_box_outlined),
                  ),
                  IconButton(
                    iconSize: 20,
                    onPressed: () {},
                    icon: const Icon(Icons.favorite),
                  ),
                  const CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://firebasestorage.googleapis.com/v0/b/instagram-7eba3.appspot.com/o/profilePics%2FNDrS3VoOVrSwUtSCNKlmUJ7kCaw1?alt=media&token=71156199-476d-4052-8eca-28ee6035302c'),
                    radius: 10,
                  )
                ],
              ),
            ),
          ],
        ),
        body: Center(
          child: isSearching
              ? Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width / 3),
                  child: FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .where('username',
                              isGreaterThanOrEqualTo: _searchController.text)
                          .get(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        return ListView.builder(
                            itemCount: (snapshot.data! as dynamic).docs.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: ((context) => ProfileCard(
                                            uid: (snapshot.data! as dynamic)
                                                .docs[index]['uid'],
                                            isNotPrimaryUser: true,
                                          )),
                                    ),
                                  );
                                },
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(8.0),
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        (snapshot.data! as dynamic).docs[index]
                                            ['photoUrl']),
                                  ),
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8.0),
                                        child: Text(
                                          (snapshot.data! as dynamic)
                                              .docs[index]['username'],
                                          style: const TextStyle(
                                            color: primaryColor,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        (snapshot.data! as dynamic).docs[index]
                                            ['name'],
                                        style: const TextStyle(
                                          color: secondaryColor,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });
                      }),
                )
              : Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width / 9),
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('posts')
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                            snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator(
                          color: primaryColor,
                        );
                      }
                      return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) => PostCard(
                                snap: snapshot.data!.docs[index].data(),
                              ));
                    },
                  ),
                ),
        ),
      ),
    );
  }
}
