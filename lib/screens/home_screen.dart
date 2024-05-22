import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:petlv/screens/Adopsi/addpost_adopsi.dart';
import 'package:petlv/screens/sign_in_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SignInScreenState signInScreenState = SignInScreenState();

  Future<bool> signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const SignInScreen()));
      return true;
    } on Exception catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/images/petlv_logo_1_removebg.png',
          width: 100,
          height: 100,
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        actions: [
          IconButton(
            onPressed: () async => Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                  builder: (context) => SizedBox()), // ProfilScreen
            ),
            icon: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(width: 2, color: Colors.black)),
              child: Icon(Icons.person_2_outlined),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(4, 1)),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Adoption',
                      style: TextStyle(
                          color: Color(0xffC67C4E),
                          fontWeight: FontWeight.bold,
                          fontSize: 34),
                    ),
                  ),
                  TextField(
                    decoration: InputDecoration(
                        labelText: 'Search...',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.search)),
                  ),
                ],
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('posts')
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              // Check error
              if (snapshot.hasError) {
                return Center(
                  child: Text('Some error occured ${snapshot.error}'),
                );
              }

              if (snapshot.hasData) {
                // Get data
                QuerySnapshot querySnapshot = snapshot.data!;
                List<QueryDocumentSnapshot> documents = querySnapshot.docs;

                //Convert the documents to Maps
                List<Map<String, dynamic>> items = documents
                    .map((e) => {
                          'id': e.id,
                          'name': e['name'],
                          'type': e['type'],
                          'age': e['age'],
                          'size': e['size'],
                          'description': e['description'],
                          'image_url': e['image_url'],
                          'email': e['email'],
                          'timestamp': e['timestamp'],
                        })
                    .toList();
                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (BuildContext context, int index) {
                    Map thisItem = items[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.count(
                        crossAxisCount: 2,
                        children: [
                          Card(
                            child: Column(
                              children: [
                                Container(
                                    child: Image.network(
                                  thisItem['image_url'],
                                  height: 250,
                                  width: 250,
                                )),
                                Row(
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          '${thisItem['name']}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text('${thisItem['age']} years old')
                                      ],
                                    ),
                                    Icon(Icons.bookmark_outline_rounded)
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ],
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(width: 2)),
        width: 150,
        child: FloatingActionButton(
          backgroundColor: Colors.white,
          onPressed: () async => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => AddPostAdoptScreen()),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(width: 2, color: Colors.black)),
                child: Icon(Icons.add),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'New Post',
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}

Widget timestaps(Map thisItem) {
  Timestamp timestamp = thisItem['timestamp'];
  DateTime dateTime = timestamp.toDate();

  return Text(
    '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}',
    style: TextStyle(fontSize: 12),
  );
}
