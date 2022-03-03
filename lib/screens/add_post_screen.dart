// ignore_for_file: avoid_print

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/models/user.dart';
import 'package:instagram/providers/user_provider.dart';
import 'package:instagram/resources/firestore_methods.dart';
import 'package:instagram/resources/storage_methods.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/utils/utils.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _img;
  final TextEditingController _descriptionController = TextEditingController();
  final StorageMethods storeData = StorageMethods();
  bool _isLoading = false;

  _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Create a post'),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            children: [
              SimpleDialogOption(
                child: const Text(
                  'Choose photo from gallery',
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List img = await pickImage(ImageSource.gallery);
                  setState(() {
                    _img = img;
                  });
                },
              ),
              SimpleDialogOption(
                child: const Text(
                  'Take a photo',
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List img = await pickImage(ImageSource.camera);
                  setState(() {
                    _img = img;
                  });
                },
              ),
              SimpleDialogOption(
                child: const Text(
                  'Cancel',
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void clearImage() {
    setState(() {
      _img = null;
    });
  }

  void createPost({
    required String username,
    required String uid,
    required String profileImage,
  }) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await FirestoreMethods().uploadPost(
        _img!,
        _descriptionController.text,
        uid,
        username,
        profileImage,
        [],
      );

      if (res != 'sucess') {
        showSnackBar(content: 'something went wrong', context: context);
      }
      clearImage();
    } catch (e) {
      showSnackBar(content: e.toString(), context: context);
      print(e);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<UserProvider>(context).getUser;

    return _img == null
        ? Center(
            child: IconButton(
              onPressed: () => _selectImage(context),
              icon: const Icon(Icons.upload),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              centerTitle: false,
              title: const Text('Post to'),
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: clearImage,
              ),
              actions: [
                TextButton(
                  onPressed: () => createPost(
                    username: user!.username,
                    uid: user.uid,
                    profileImage: user.photoUrl,
                  ),
                  child: const Text(
                    'Post',
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
            body: Column(
              children: [
                _isLoading
                    ? const Center(
                        child: LinearProgressIndicator(
                          color: primaryColor,
                        ),
                      )
                    : Container(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(user!.photoUrl),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: TextField(
                        controller: _descriptionController,
                        maxLines: 8,
                        decoration: const InputDecoration(
                            hintText: 'Write a caption..',
                            border: InputBorder.none),
                      ),
                    ),
                    SizedBox(
                      height: 45,
                      width: 45,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: MemoryImage(_img!),
                                fit: BoxFit.fill,
                                alignment: FractionalOffset.topCenter),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
  }
}
