import 'package:fire_base_operations/model/list_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CrudScreen extends StatefulWidget {
  const CrudScreen({super.key});

  @override
  State<CrudScreen> createState() => _CrudScreenState();
}

class _CrudScreenState extends State<CrudScreen> {
  final firstData = TextEditingController();
  final seconddata = TextEditingController();
  List<ListModel> listData = [];

  CollectionReference employeeCollection =
      FirebaseFirestore.instance.collection('employee');
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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      listData.add(
                        ListModel(
                          firstData: firstData.text.trim(),
                          secondData: seconddata.text.trim(),
                        ),
                      );
                      setState(() {});
                      firstData.clear();
                      seconddata.clear();
                    },
                    child: Text("Add"),
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
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(employee['name']),
                                    Text(employee['designation']),
                                  ],
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {},
                                      icon: Icon(Icons.edit),
                                    ),
                                    IconButton(
                                      onPressed: () {},
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
