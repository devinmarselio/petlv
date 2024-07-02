import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petlv/screens/Adopsi/addpost_adopsi.dart';

class EditAdoptPostPage extends StatefulWidget {
  final DocumentSnapshot post;

  EditAdoptPostPage({required this.post});

  @override
  _EditAdoptPostPageState createState() => _EditAdoptPostPageState();
}

class _EditAdoptPostPageState extends State<EditAdoptPostPage> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _postTextController = TextEditingController();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _sizeController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  String? _selectedType;
  String? _imageUrl;

  final List<String> _typeItems = ['Dog', 'Cat'];

  @override
  void initState() {
    super.initState();
    _imageUrl = widget.post['image_url'];
    _selectedType = widget.post['type'];
    _nameController.text = widget.post['name'];
    _ageController.text = widget.post['age'];
    _sizeController.text = widget.post['size'];
    _postTextController.text = widget.post['description'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Adopt Post'),
        actions: [
          IconButton(
              onPressed: () async {
                await _showDeleteDialog();
              },
              icon: Icon(Icons.delete)),
        ],
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
                  decoration: InputDecoration(
                    hintText: 'Enter name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Kolom tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                Text('Type'),
                DropdownButtonFormField<String>(
                  value: _selectedType,
                  validator: (value) =>
                      value == null ? 'Kolom tidak boleh kosong' : null,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  items: _typeItems.map((String type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (String? newType) {
                    setState(() {
                      _selectedType = newType;
                    });
                  },
                ),
                SizedBox(height: 16),
                Text('Age'),
                TextFormField(
                  controller: _ageController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Kolom tidak boleh kosong';
                    }
                    return null;
                  },
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  ],
                  decoration: InputDecoration(
                    hintText: 'Enter age',
                    suffixText: 'Month',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                SizedBox(height: 16),
                Text('Size'),
                TextFormField(
                  controller: _sizeController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Kolom tidak boleh kosong';
                    }
                    return null;
                  },
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  ],
                  decoration: InputDecoration(
                    hintText: 'Enter size',
                    suffixText: 'kg',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  maxLines: 1,
                ),
                SizedBox(height: 16),
                Text('Description'),
                TextFormField(
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
                          : _imageUrl != null
                              ? Image.network(_imageUrl!)
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
                          try {
                            if (_image != null) {
                              Reference referenceRoot =
                                  FirebaseStorage.instance.ref();
                              Reference referenceDirImages =
                                  referenceRoot.child("images");
                              Reference referenceImagesToUpload =
                                  referenceDirImages
                                      .child(_image!.path.split("/").last);
                              final uploadTask = await referenceImagesToUpload
                                  .putFile(File(_image!.path));
                              final downloadUrl =
                                  await uploadTask.ref.getDownloadURL();
                              _imageUrl = downloadUrl;
                            }

                            _firestore
                                .collection('posts')
                                .doc(widget.post.id)
                                .update({
                              'name': _nameController.text,
                              'type': _selectedType,
                              'age': _ageController.text,
                              'size': _sizeController.text,
                              'description': _postTextController.text,
                              'image_url': _imageUrl,
                            });
                            Navigator.of(context).pop();
                          } catch (e) {}
                        }
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                              Theme.of(context).colorScheme.primary)),
                      child: Text(
                        'Save Edits',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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

  Future<void> _showDeleteDialog() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text('Are You Sure To Delete This Post?'),
        content: Text(
            'If you sure, press Delete and this post will permanently deleted'),
        actions: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius: BorderRadius.circular(15)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(Colors.grey.shade400)),
                  child: Text(
                    'Delete',
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () async {
                    try {
                      await _firestore
                          .collection('posts')
                          .doc(widget.post.id)
                          .delete();
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    } catch (e) {}
                  },
                ),
                TextButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                          Theme.of(context).colorScheme.primary)),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
