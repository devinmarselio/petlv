import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

class detailPostAdoptScreen extends StatefulWidget {
  const detailPostAdoptScreen({super.key});

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
                  child: const Placeholder(),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                // Nama Peliharaan
                const Text(
                  'Cicowalaca',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(
                  height: 40.0,
                ),
                // Deskripsi Peliharaan
                const Text('Description'),
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
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                child: Text("Type"),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                child: Text(": Anjing"),
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
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                child: Text("Type"),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                child: Text(": Anjing"),
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
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                child: Text("Type"),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                child: Text(": Anjing"),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                child: Text("Type "),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                child: Text(":"),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                child: Text(" Anjing"),
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
