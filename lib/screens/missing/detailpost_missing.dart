import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class DetailPostMissingScreen extends StatefulWidget {
  final String name;
  final String email;
  final String lastseen;
  final String status;
  final String description;
  final String image_url;
  final Timestamp timestamp;
  final String username;
  final String phoneNumber;

  const DetailPostMissingScreen(
      {super.key,
      required this.name,
      required this.email,
      required this.lastseen,
      required this.status,
      required this.description,
      required this.image_url,
      required this.timestamp,
      required this.username,
      required this.phoneNumber});

  @override
  State<DetailPostMissingScreen> createState() =>
      _DetailPostMissingScreenState();
}

class _DetailPostMissingScreenState extends State<DetailPostMissingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _commentController = TextEditingController();
  final _replyController = TextEditingController();
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
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: Row(
                  children: [
                    Text(
                      widget.name,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    Text(
                      widget.status,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              const Divider(
                color: Colors.black,
                height: 2.0,
              ),
              const SizedBox(height: 20.0),
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
              Row(
                children: [
                  Expanded(
                    flex: 8,
                    child: Container(
                      child: Text("Published Date"),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: Text(": "),
                    ),
                  ),
                  Expanded(
                    flex: 10,
                    child: Container(
                      child: Text(DateFormat('MM/dd/yyyy, hh:mm a')
                          .format(widget.timestamp.toDate())),
                    ),
                  ),
                ],
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
                  "Owner Contact",
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
                            flex: 8,
                            child: Container(
                              child: Text("Name"),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              child: Text(": "),
                            ),
                          ),
                          Expanded(
                            flex: 10,
                            child: Container(
                              child: Text(widget.username),
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
                            flex: 8,
                            child: Container(
                              child: Text("Number"),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              child: Text(": "),
                            ),
                          ),
                          Expanded(
                            flex: 10,
                            child: Container(
                              child: Text(widget.phoneNumber),
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
                            flex: 8,
                            child: Container(
                              child: Text("Email"),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              child: Text(": "),
                            ),
                          ),
                          Expanded(
                            flex: 10,
                            child: Container(
                              child: Text(widget.email),
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
                header: Row(
                  children: [
                    Text(
                      "Comments",
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.name,
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                  ],
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
                          return Column(
                            children: [
                              ListTile(
                                title: Text(_comments[index].username),
                                subtitle: Text(_comments[index].text),
                              ),
                              // Display replies
                              Column(
                                children: _comments[index].replies.map((reply) {
                                  return ListTile(
                                    title: Text(reply.username),
                                    subtitle: Text(reply.text),
                                  );
                                }).toList(),
                              ),
                              Row(
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      // Munculkan form untuk mengisi balasan komentar
                                      _showReplyForm(index);
                                    },
                                    child: Text('Reply'),
                                  ),
                                ],
                              ),
                            ],
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

  void _addReply(int index) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final String username = '${widget.email}'; // replace with actual username
    final String text = _replyController.text;

    try {
      final commentDocRef = _firestore
          .collection('posts')
          .doc(widget.name)
          .collection('comments')
          .doc(_comments[index].id);

      final replyDocRef = await commentDocRef.collection('replies').add({
        'username': username,
        'text': text,
      });

      setState(() {
        _comments[index].replies.add(Reply(text: text, username: username));
        _comments = [
          ..._comments
        ]; // Update the _comments list with the new reply
        _replyController.clear();
      });
    } catch (e) {
      print('Error adding reply: $e');
    }
  }

  void _showReplyForm(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Reply to ${_comments[index].username}'),
          content: Form(
            child: TextFormField(
              controller: _replyController, // Use the _replyController here
              decoration: InputDecoration(
                labelText: 'Write a reply...',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a reply';
                }
                return null;
              },
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (_replyController.text.isNotEmpty) {
                  Navigator.of(context).pop(); // Close the dialog
                  _addReply(
                      index); // Call the _addReply function with the index parameter
                } else {
                  // Show an error message or alert the user to enter a reply
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter a reply')),
                  );
                }
              },
              child: Text('Post'),
            ),
          ],
        );
      },
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
      _comments = snapshot.docs.map((doc) {
        final comment = Comment.fromMap(doc.data());
        comment.id = doc.id;
        return comment;
      }).toList();
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
  String id = '';
  String username;
  String text;
  List<Reply> replies = [];

  Comment(
      {this.id = '',
      required this.username,
      required this.text,
      this.replies = const []});

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id'] ??
          '', // provide a default value if 'id' is not present in the map
      username: map['username'],
      text: map['text'],
    );
  }
}

class Reply {
  String text;
  String username;

  Reply({required this.text, required this.username});
}
