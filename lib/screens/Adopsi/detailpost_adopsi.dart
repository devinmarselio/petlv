import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class detailPostAdoptScreen extends StatefulWidget {
  final String name;
  final String email;
  final String type;
  final String age;
  final String size;
  final String description;
  final String image_url;
  final Timestamp timestamp;

  const detailPostAdoptScreen({
    super.key,
    required this.name,
    required this.email,
    required this.type,
    required this.age,
    required this.size,
    required this.description,
    required this.image_url,
    required this.timestamp,
  });

  @override
  State<detailPostAdoptScreen> createState() => _detailPostAdoptScreenState();
}

class _detailPostAdoptScreenState extends State<detailPostAdoptScreen> {
  final _formKey = GlobalKey<FormState>();
  final _commentController = TextEditingController();
  List<Comment> _comments = [];

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        centerTitle: true,
        title: const Text('Detail'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Foto Peliharaan
              Container(
                width: double
                    .infinity, // tambahkan width untuk membuat gambar lebih kecil
                height: 280,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    widget.image_url,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              // Nama Peliharaan
              Text(
                widget.name,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40.0),
              // Deskripsi Peliharaan
              Text(
                widget.description,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20.0),
              const Divider(
                color: Colors.black,
                height: 2.0,
              ),
              const SizedBox(height: 20.0),
              // Informasi Peliharaan
              ExpandablePanel(
                header: const Text(
                  "Information",
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                collapsed: const Text(""),
                expanded: Padding(
                  padding: const EdgeInsets.all(16.0),
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
                      const SizedBox(height: 10.0),
                      Divider(
                        color: Colors.black,
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
                      const SizedBox(height: 10.0),
                      Divider(
                        color: Colors.black,
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
                      const SizedBox(height: 10.0),
                      Divider(
                        color: Colors.black,
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
                              child: Text(
                                  ": ${DateFormat('MM/dd/yyyy, hh:mm a').format(widget.timestamp.toDate())}"),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      Divider(
                        color: Colors.black,
                        height: 2.0,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              // Komentar
              ExpandablePanel(
                header: const Text(
                  "Comments",
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                collapsed: const Text(""),
                expanded: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _comments.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(_comments[index].username),
                            subtitle: Text(_comments[index].text),
                          );
                        },
                      ),
                      const SizedBox(height: 10.0),
                      Form(
                        key: _formKey,
                        child: TextFormField(
                          controller: _commentController,
                          decoration: const InputDecoration(
                            labelText: 'Write a comment...',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a comment';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _addComment();
                          }
                        },
                        child: const Text('Post Comment'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _loadComments() async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
        .collection('posts')
        .doc(widget.name)
        .collection('comments')
        .get();

    setState(() {
      _comments =
          snapshot.docs.map((doc) => Comment.fromMap(doc.data())).toList();
    });
  }

  void _addComment() async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final String username = '${widget.email}'; // replace with actual username
    final String text = _commentController.text;

    await _firestore
        .collection('posts')
        .doc(widget.name)
        .collection('comments')
        .add({
      'username': username,
      'text': text,
    });

    setState(() {
      _comments.add(Comment(text: text, username: username));
      _commentController.clear();
    });
  }
}

class Comment {
  String text;
  String username;

  Comment({required this.text, required this.username});

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      text: map['text'],
      username: map['username'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'username': username,
    };
  }
}
