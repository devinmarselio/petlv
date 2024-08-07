import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:petlv/screens/Adopsi/addpost_adopsi.dart';
import 'package:petlv/screens/Adopsi/detailpost_adopsi.dart';
import 'package:petlv/screens/profile_screen.dart';
import 'package:petlv/screens/search_screen.dart';
import 'package:petlv/screens/services/buttocks_bar.dart';
import 'package:petlv/screens/sign_in_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedType = '';
  String _userID = '';
  int? _age;
  String? _size;
  @override
  void initState() {
    _storeCredential();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _storeCredential() async {
    final token = await FirebaseMessaging.instance.getToken();
    _userID = FirebaseAuth.instance.currentUser!.uid;
    if (_userID != null) {
      FirebaseFirestore.instance.collection('users').doc(_userID).update({
        'deviceToken': token,
      });
      print(token);
      print(_userID);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Image.asset(
          color: Theme.of(context).colorScheme.secondary,
          'assets/images/petlv_logo_1_removebg.png',
          width: 100,
          height: 100,
        ),
        actions: [
          IconButton(
            onPressed: () async => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            ),
            icon: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                      width: 2,
                      color: Theme.of(context).colorScheme.secondary)),
              child: const Icon(Icons.person_2_outlined),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                    color: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(4, 1)),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(10.0),
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
                  SizedBox(
                    height: 50,
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(cardColor: Colors.transparent),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                side: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Search...',
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontSize: 16),
                            ),
                            Icon(
                              Icons.search,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ],
                        ),
                        onPressed: () async {
                          final result = await Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => SearchScreen()),
                          );
                          if (result != null) {
                            setState(() {
                              _searchQuery = result['searchQuery'];
                              _selectedType = result['selectedType'];
                              _age = result['age'];
                              _size = result['size'];
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Some error occured ${snapshot.error}'),
                  );
                }
                if (snapshot.hasData) {
                  QuerySnapshot querySnapshot = snapshot.data!;
                  List<QueryDocumentSnapshot> documents = querySnapshot.docs;

                  // Filter data based on search query
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
                            'username': e['username'],
                            'phoneNumber': e['phoneNumber'],
                            'location': e['location'],
                            'isFavorite': e['isFavorite'] ?? false,
                            'deviceToken': (e.data() as Map<String, dynamic>)
                                    .containsKey('deviceToken')
                                ? e['deviceToken']
                                : null,
                            'userID': (e.data() as Map<String, dynamic>)
                                    .containsKey('userID')
                                ? e['userID']
                                : null,
                          })
                      .where((item) {
                        return item.containsValue(_searchQuery) ||
                            item.values.any((value) => value
                                .toString()
                                .toLowerCase()
                                .contains(_searchQuery));
                      })
                      .where((item) =>
                          _selectedType.isEmpty ||
                          _selectedType == 'All' ||
                          item['type'] == _selectedType)
                      .where((item) => _age == null || item['age'] == _age)
                      .where((item) => _size == null || item['size'] == _size)
                      .toList();

                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: MediaQuery.of(context).orientation ==
                              Orientation.landscape
                          ? 3
                          : 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: (1 / 1.2),
                    ),
                    itemCount: items.length,
                    itemBuilder: (BuildContext context, int index) {
                      Map thisItem = items[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () async => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => detailPostAdoptScreen(
                                name: thisItem['name'],
                                email: thisItem['email'],
                                type: thisItem['type'],
                                age: thisItem['age'],
                                size: thisItem['size'],
                                description: thisItem['description'],
                                image_url: thisItem['image_url'],
                                timestamp: thisItem['timestamp'],
                                username: thisItem['username'],
                                phoneNumber: thisItem['phoneNumber'],
                                location: thisItem['location'],
                                deviceToken: thisItem['deviceToken'],
                                userID: thisItem['userID'],
                              ),
                            ),
                          ),
                          child: Card(
                            child: Column(
                              children: [
                                Container(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.network(
                                      thisItem['image_url'],
                                      height: 150,
                                      width: 150,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Column(
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            '${thisItem['name']}',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Text('${thisItem['age']} month old')
                                      ],
                                    ),
                                    const Expanded(child: SizedBox()),
                                    IconButton(
                                      icon: Icon(
                                        thisItem['isFavorite']
                                            ? Icons.bookmark
                                            : Icons.bookmark_outline,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                      onPressed: () async {
                                        setState(() {
                                          thisItem['isFavorite'] =
                                              !thisItem['isFavorite'];
                                        });
                                        // Simpan status favorit ke Firestore
                                        await FirebaseFirestore.instance
                                            .collection('posts')
                                            .doc(thisItem['id'])
                                            .update({
                                          'isFavorite': thisItem['isFavorite']
                                        });
                                      },
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
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
          ),
          SizedBox(height: 80)
        ],
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
              width: 3, color: Theme.of(context).colorScheme.secondary),
        ),
        width: 150,
        child: FloatingActionButton(
          backgroundColor: Theme.of(context).colorScheme.background,
          onPressed: () async => Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => AddPostAdoptScreen(
                      userID: _userID,
                    )),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                        width: 2,
                        color: Theme.of(context).colorScheme.secondary)),
                child: Icon(
                  Icons.add,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                'New Post',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary),
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
    style: const TextStyle(fontSize: 12),
  );
}
