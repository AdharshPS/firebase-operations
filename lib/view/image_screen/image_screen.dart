import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageScreen extends StatefulWidget {
  const ImageScreen({super.key});

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  String url = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * .95,
              height: 400,
              child: Image.network(url),
              // decoration: BoxDecoration(
              //   color: Colors.grey,
              //   image: DecorationImage(
              //     image: FileImage(
              //       File(url),
              //     ),
              //   ),
              // ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final uniqueNameStamp = DateTime.now().microsecondsSinceEpoch;

              // pick image
              XFile? image =
                  await ImagePicker().pickImage(source: ImageSource.camera);

              if (image != null) {
                // create a root reference
                final stroageRef = FirebaseStorage.instance.ref();

                // create a folder reference
                Reference? imageRef = stroageRef.child("images");

                // reference to image path
                final uploadRef = imageRef.child(uniqueNameStamp.toString());

                // put image to path
                await uploadRef.putFile(File(image.path));

                // get image download url
                final downloadUrl = await uploadRef.getDownloadURL();
                url = downloadUrl;
              } else {
                url = "";
              }
              setState(() {});
            },
            child: Text("Add"),
          ),
          SizedBox(height: 50),
        ],
      ),
    );
  }
}
