import 'package:flutter/material.dart';
import 'package:instagram/utils/colors.dart';

class LikedByCard extends StatelessWidget {
  const LikedByCard({
    Key? key,
    required this.photoUrl,
    required this.username,
    required this.name,
  }) : super(key: key);

  final photoUrl;
  final username;
  final name;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(photoUrl),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(username),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(name,
                      style: const TextStyle(
                        color: secondaryColor,
                      )),
                ],
              ),
              const Expanded(child: SizedBox()),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: ElevatedButton(
                  child: const Text('Follow'),
                  onPressed: () {},
                ),
              ),
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }
}
