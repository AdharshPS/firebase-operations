import 'dart:io';

import 'package:fire_base_operations/controller/add_data_controller.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class CrudScreen extends StatefulWidget {
  const CrudScreen({super.key});

  @override
  State<CrudScreen> createState() => _CrudScreenState();
}

class _CrudScreenState extends State<CrudScreen> {
  String url = "";

  final firstData = TextEditingController();
  final seconddata = TextEditingController();

  bool isUpdating = false;

// creating or opening a collection
  CollectionReference employeeCollection =
      FirebaseFirestore.instance.collection('employee');

  dynamic empId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
              child: TextFormField(
                controller: firstData,
                decoration: InputDecoration(
                  hintText: "enter the data",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
              child: TextFormField(
                controller: seconddata,
                decoration: InputDecoration(
                  hintText: "enter the data",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Image.network(
                    url,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: ElevatedButton(
                    onPressed: () async {
                      final uniqueNameStamp =
                          DateTime.now().microsecondsSinceEpoch;

                      // pick image
                      XFile? image = await ImagePicker()
                          .pickImage(source: ImageSource.camera);

                      if (image != null) {
                        // create a root reference
                        final stroageRef = FirebaseStorage.instance.ref();

                        // create a folder reference
                        Reference? imageRef = stroageRef.child("images");

                        // reference to image path
                        final uploadRef =
                            imageRef.child(uniqueNameStamp.toString());

                        // put image to path
                        await uploadRef.putFile(
                          File(image.path),
                        );

                        // get image download url
                        final downloadUrl = await uploadRef.getDownloadURL();
                        url = downloadUrl;
                      } else {
                        url = "";
                      }
                      setState(() {});
                    },
                    child: Text("Image"),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      // listData.add(
                      //   ListModel(
                      //     firstData: firstData.text.trim(),
                      //     secondData: seconddata.text.trim(),
                      //   ),
                      // );
                      isUpdating == true
                          ? AddDataController().updateUser(
                              employee: employeeCollection,
                              empId: empId,
                              name: firstData.text.trim(),
                              des: seconddata.text.trim(),
                            )
                          : AddDataController().addUser(
                              employee: employeeCollection,
                              url: url,
                              name: firstData.text.trim(),
                              des: seconddata.text.trim(),
                            );
                      setState(() {});
                      firstData.clear();
                      seconddata.clear();
                      url = "";
                      isUpdating = false;
                    },
                    child: Text(isUpdating == true ? "Update" : "Add"),
                  ),
                ),
              ],
            ),
            StreamBuilder(
              stream: employeeCollection.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Expanded(
                    child: ListView.separated(
                      itemCount: snapshot.data!.docs.length,
                      separatorBuilder: (context, index) => SizedBox(
                        height: 10,
                      ),
                      itemBuilder: (context, index) {
//  document snapshot
                        DocumentSnapshot employee = snapshot.data!.docs[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Container(
                            padding: EdgeInsets.all(5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      child: Image.network(employee['image']),
                                    ),
                                    SizedBox(width: 10),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(employee['name']),
                                        Text(employee['designation']),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        firstData.text = employee['name'];
                                        seconddata.text =
                                            employee['designation'];
                                        empId = employee.id;
                                        isUpdating = true;
                                        setState(() {});
                                      },
                                      icon: Icon(Icons.edit),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        AddDataController().deleteUser(
                                            empId: employee.id,
                                            employee: employeeCollection);
                                      },
                                      icon: Icon(Icons.delete),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return Center(
                    child: Text("no data found"),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
