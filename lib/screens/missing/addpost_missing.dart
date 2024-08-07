import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:petlv/screens/services/buttocks_bar.dart';

class AddPostMissing extends StatefulWidget {
  String userID;

  AddPostMissing({super.key, required this.userID});

  @override
  _AddPostMissingState createState() => _AddPostMissingState();
}

class _AddPostMissingState extends State<AddPostMissing> {
  final _postTextController = TextEditingController();
  final _nameController = TextEditingController();
  final _lastseenController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  XFile? _image;
  String _username = '';
  String _phoneNumber = '';
  String _deviceToken = '';
  String _userID = '';
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  @override
  void initState() {
    _loadUserData();
    _userID = widget.userID;
    print(_userID);
    super.initState();
  }

  Future<void> _loadUserData() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();
      if (snapshot.exists) {
        setState(() {
          _username = snapshot.data()!['username'];
          _phoneNumber = snapshot.data()!['phoneNumber'];
          _deviceToken = snapshot.data()!['deviceToken'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back)),
          title: Text('Missing Post'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Name'),
                  TextFormField(
                    controller: _nameController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Kolom tidak boleh kosong';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter name',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text('Last Seen'),
                  TextFormField(
                    controller: _lastseenController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Kolom tidak boleh kosong';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter last seen',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text('Description'),
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    controller: _postTextController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Kolom tidak boleh kosong';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter your description',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  SizedBox(height: 16),
                  GestureDetector(
                    onTap: () async {
                      await _showImageSourceDialog();
                    },
                    child: Center(
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: _image != null
                            ? Image.file(File(_image!.path))
                            : Icon(Icons.camera_alt),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: SizedBox(
                      width: 400,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            if (_image == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('Please select an image')),
                              );
                              return;
                            }
                            setState(() {
                              isLoading = true;
                            });
                            Reference referenceRoot =
                                FirebaseStorage.instance.ref();
                            Reference referenceDirImages =
                                referenceRoot.child("images");
                            Reference referenceImagesToUpload =
                                referenceDirImages
                                    .child(_image!.path.split("/").last);
                            try {
                              final uploadTask = await referenceImagesToUpload
                                  .putFile(File(_image!.path));
                              final downloadUrl =
                                  await uploadTask.ref.getDownloadURL();

                              // Add Firebase Cloud Firestore functionality here
                              final CollectionReference posts2 =
                                  FirebaseFirestore.instance
                                      .collection('posts2');
                              final User? user = _auth.currentUser;
                              final String? userEmail = user?.email;
                              await posts2.add({
                                'name': _nameController.text,
                                'lastseen': _lastseenController.text,
                                'status': 'Still Missing',
                                'description': _postTextController.text,
                                'image_url': downloadUrl,
                                'email': userEmail,
                                'timestamp': Timestamp.now(),
                                'username': _username,
                                'phoneNumber': _phoneNumber,
                                'deviceToken': _deviceToken,
                                'userID' : _userID,
                              });
                              setState(() {
                                isLoading = false;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                        Text('Image uploaded successfully')),
                              );
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BottomNavBarScreen()),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('Error uploading image: $e')),
                              );
                            }
                          }
                        },
                        child:
                            Text('Post', style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xffC67C4E)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      isLoading
          ? Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Container(),
    ]);
  }

  Future<void> _showImageSourceDialog() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Choose Image Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('Take a new photo'),
              onTap: () async {
                Navigator.of(context).pop();
                final pickedFile =
                    await _picker.pickImage(source: ImageSource.camera);
                if (pickedFile != null) {
                  setState(() {
                    _image = pickedFile;
                  });
                }
              },
            ),
            ListTile(
              title: Text('Choose from library'),
              onTap: () async {
                Navigator.of(context).pop();
                final pickedFile =
                    await _picker.pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  setState(() {
                    _image = pickedFile;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _postTextController.dispose();
    _nameController.dispose();
    _lastseenController.dispose();
    super.dispose();
  }
}
