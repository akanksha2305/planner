import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:planner/widgets/widgets.dart';

class ImageUpload extends StatefulWidget {
  String? userId;
  ImageUpload({super.key, this.userId});

  @override
  State<ImageUpload> createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  File? _image;
  String? DownloadUrl;
  final imagePicker = ImagePicker();

  Future imagePickerMethod() async {
    final pick = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pick != null) {
        _image = File(pick.path);
      } else {
        showSnackBar(
          context,
          Colors.red,
          Text("No Image Selected"),
        );
      }
    });
  }

  Future uploadImage() async {
    final postID = DateTime.now().millisecondsSinceEpoch.toString();
    Reference ref = FirebaseStorage.instance
        .ref()
        .child("${widget.userId}/image")
        .child("post_${postID}");
    await ref.putFile(_image!);
    DownloadUrl = await ref.getDownloadURL();
    print(DownloadUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: SizedBox(
              height: 500,
              width: double.infinity,
              child: Column(
                children: [
                  Text(
                    "Upload Image",
                    style: TextStyle(
                      fontSize: 30,
                      fontFamily: "Lexend",
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    flex: 5,
                    child: Container(
                      width: 300,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.15),
                            blurRadius: 30,
                            offset: Offset(0, 10),
                          ),
                        ],
                        border: Border.all(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: _image == null
                                  ? Center(
                                      child: Text(
                                        "No Image Selected",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: "Lexend",
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    )
                                  : Image.file(_image!),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.75,
                                height:
                                    MediaQuery.of(context).size.height * 0.037,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Theme.of(context).primaryColor,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        imagePickerMethod();
                                      },
                                      child: Text(
                                        "Select Image",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontFamily: "Lexend",
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        if (_image != null) {
                                          uploadImage().whenComplete(() => {
                                                FirebaseFirestore.instance
                                                    .collection("users")
                                                    .doc(widget.userId)
                                                    .update({
                                                  "profilePic": DownloadUrl,
                                                }),
                                                showSnackBar(
                                                  context,
                                                  Colors.green,
                                                  "Image Uploaded",
                                                ),
                                              });
                                        } else {
                                          showSnackBar(
                                            context,
                                            Colors.red,
                                            "No Image Selected",
                                          );
                                        }
                                      },
                                      child: Text(
                                        "Upload Image",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontFamily: "Lexend",
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
