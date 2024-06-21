import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:petlv/screens/home_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class AddPostAdoptScreen extends StatefulWidget {
  @override
  _AddPostAdoptScreenState createState() => _AddPostAdoptScreenState();
}

class _AddPostAdoptScreenState extends State<AddPostAdoptScreen> {
  final _postTextController = TextEditingController();
  final _typeController = TextEditingController();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _sizeController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  String? _selectedType;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final List<String> _typeItems = ['Dog', 'Cat'];
  String _username = '';
  String _phoneNumber = '';
  LatLng? _location;
  @override
  void initState() {
    super.initState();
    _loadUserData();
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
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back)),
        title: Text('Adoption Post'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name'),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Enter name',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              SizedBox(height: 16),
              Text('Type'),
              DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: InputDecoration(
                  hintText: 'Select type',
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
              TextField(
                controller: _ageController,
                decoration: InputDecoration(
                  hintText: 'Enter age',
                  suffixText: 'Month',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              SizedBox(height: 16),
              Text('Size'),
              TextField(
                controller: _sizeController,
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
              TextField(
                controller: _postTextController,
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
                      if (_image == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please select an image')),
                        );
                        return;
                      }
                      _location = await CurrentLocation.getCurrentLocation();
                      Reference referenceRoot = FirebaseStorage.instance.ref();
                      Reference referenceDirImages =
                          referenceRoot.child("images");
                      Reference referenceImagesToUpload = referenceDirImages
                          .child(_image!.path.split("/").last);
                      try {
                        final uploadTask = await referenceImagesToUpload
                            .putFile(File(_image!.path));
                        final downloadUrl =
                            await uploadTask.ref.getDownloadURL();

                        // Add Firebase Cloud Firestore functionality here
                        final CollectionReference posts =
                            FirebaseFirestore.instance.collection('posts');
                        final User? user = _auth.currentUser;
                        final String? userEmail = user?.email;
                        await posts.add({
                          'name': _nameController.text,
                          'type': _selectedType,
                          'age': _ageController.text,
                          'size': _sizeController.text,
                          'description': _postTextController.text,
                          'image_url': downloadUrl,
                          'email': userEmail,
                          'timestamp': Timestamp.now(),
                          'username': _username,
                          'phoneNumber': _phoneNumber,
                          'location': GeoPoint(
                              _location!.latitude, _location!.longitude),
                          'isFavorite': false
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Image uploaded successfully')),
                        );
                        await Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error uploading image: $e')),
                        );
                      }
                    },
                    child: Text('Post', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xffC67C4E)),
                  ),
                ),
              ),
            ],
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

  @override
  void dispose() {
    _postTextController.dispose();
    _typeController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    _sizeController.dispose();
    super.dispose();
  }
}

class LatLng {
  final double latitude;
  final double longitude;

  LatLng({required this.latitude, required this.longitude});
}

class CurrentLocation {
  static Future<LatLng> getCurrentLocation() async {
    final status = await Permission.location.status;
    if (!status.isGranted) {
      final result = await Permission.location.request();
      if (result != PermissionStatus.granted) {
        throw 'Location permission denied';
      }
    }

    try {
      final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      return LatLng(latitude: position.latitude, longitude: position.longitude);
    } catch (e) {
      throw 'Error getting current location: $e';
    }
  }
}
