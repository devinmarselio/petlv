import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class detailPostAdoptScreen extends StatefulWidget {
  final String name;
  final String type;
  final String age;
  final String size;
  final String description;
  final String image_url;
  final Timestamp timestamp;

  const detailPostAdoptScreen(
      {super.key,
      required this.name,
      required this.type,
      required this.age,
      required this.size,
      required this.description,
      required this.image_url, required this.timestamp});

  @override
  State<detailPostAdoptScreen> createState() => _detailPostAdoptScreenState();
}

class _detailPostAdoptScreenState extends State<detailPostAdoptScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Scaffold(
        appBar: AppBar(
          // Tombol Back
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
            ),
          ),
          centerTitle: true,
          title: const Text(
            'Detail',
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Foto Peliharaan
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(20)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                        widget.image_url,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                // Nama Peliharaan
                Text(
                  widget.name,
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(
                  height: 40.0,
                ),
                // Deskripsi Peliharaan
                Text(
                  widget.description
                ),
                const SizedBox(
                  height: 20.0,
                ),
                const Divider(
                  color: Colors.amber,
                  height: 2.0,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                // Informasi Peliharaan
                ExpandablePanel(
                  header: const Text(
                    "Information",
                    style: TextStyle(fontSize: 20.0),
                  ),
                  collapsed: const Text(""),
                  expanded: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: Container(
                                child: Text("Type"),
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Container(
                                child: Text(": ${widget.type}"),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Divider(
                          color: Colors.amber,
                          height: 2.0,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: Container(
                                child: Text("Age"),
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Container(
                                child: Text(": ${widget.age} Bulan"),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Divider(
                          color: Colors.amber,
                          height: 2.0,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: Container(
                                child: Text("Size"),
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Container(
                                child: Text(": ${widget.size} kg"),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Divider(
                          color: Colors.amber,
                          height: 2.0,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: Container(
                                child: Text("Published Date"),
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Container(
                                child: Text(": ${DateFormat('MM/dd/yyyy, hh:mm a').format(widget.timestamp.toDate())}"),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Divider(
                          color: Colors.amber,
                          height: 2.0,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
