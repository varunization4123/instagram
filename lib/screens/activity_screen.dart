// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class ActivityScreen extends StatefulWidget {
//   const ActivityScreen({Key? key}) : super(key: key);

//   @override
//   State<ActivityScreen> createState() => _ActivityScreenState();
// }

// class _ActivityScreenState extends State<ActivityScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(10.0),
//       child: Column(
//         children: [
//           const Text('Today'),
//           StreamBuilder(
//             stream: FirebaseFirestore.instance
//                 .collection('posts')
//                 .where('likes', arrayContains: uid)
//                 .snapshots(),
//             builder: (context, snapshot) {},
//           )
//         ],
//       ),
//     );
//   }
// }
