import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram/screens/profile_screen.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/widgets/profile_card.dart';
import 'package:instagram/widgets/search_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool isSearching = false;

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          title: TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(15)),
              label: Row(
                children: const [
                  Icon(Icons.search),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                    child: Text('Search'),
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
        body: isSearching
            ? Padding(
                padding: const EdgeInsets.all(15.0),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: Text(
                                        (snapshot.data! as dynamic).docs[index]
                                            ['username'],
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
            : StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection('posts').snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(
                      color: primaryColor,
                    );
                  }
                  return GridView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) => SearchCard(
                      snap: snapshot.data!.docs[index].data(),
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 0.1,
                      crossAxisSpacing: 0.1,
                    ),
                  );
                },
              ),
      ),
    );
  }
}
