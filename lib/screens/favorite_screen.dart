import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petlv/screens/Adopsi/detailpost_adopsi.dart';
import 'package:petlv/screens/profile_screen.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Favorite',
                      style: TextStyle(
                          color: Color(0xffC67C4E),
                          fontWeight: FontWeight.bold,
                          fontSize: 34),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                          labelText: 'Search...',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.search)),
                      onChanged: (query) {
                        setState(() {
                          _searchQuery = query.toLowerCase();
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .where('isFavorite', isEqualTo: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  QuerySnapshot querySnapshot = snapshot.data!;
                  List<QueryDocumentSnapshot> documents = querySnapshot.docs;
                  List<Map<String, dynamic>> items = documents
                      .map((e) => {
                            'id': e.id,
                            'name': e['name'],
                            'type': e['type'],
                            'age': e['age'],
                            'ize': e['size'],
                            'description': e['description'],
                            'image_url': e['image_url'],
                            'email': e['email'],
                            'timestamp': e['timestamp'],
                            'username': e['username'],
                            'phoneNumber': e['phoneNumber'],
                            'isFavorite': e['isFavorite'] ?? false,
                          })
                      .where((item) {
                    return item.containsValue(_searchQuery) ||
                        item.values.any((value) => value
                            .toString()
                            .toLowerCase()
                            .contains(_searchQuery));
                  }).toList();
                  return GridView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: items.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.6,
                      mainAxisSpacing: 8.0,
                      crossAxisSpacing: 8.0,
                    ),
                    itemBuilder: (context, index) {
                      Map thisItem = items[index];
                      final post = snapshot.data!.docs[index];
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
                              ),
                            ),
                          ),
                          child: GridTile(
                            child: Image.network(post['image_url'],
                                fit: BoxFit.cover),
                            footer: GridTileBar(
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .background
                                  .withOpacity(0.5),
                              title: Text(
                                post['name'],
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                              ),
                              subtitle: Text(
                                post['type'],
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                              ),
                              trailing: IconButton(
                                icon: Icon(
                                  post['isFavorite']
                                      ? Icons.bookmark
                                      : Icons.bookmark_outline,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                                onPressed: () async {
                                  // Update status favorit di Firestore
                                  await FirebaseFirestore.instance
                                      .collection('posts')
                                      .doc(post.id)
                                      .update(
                                          {'isFavorite': !post['isFavorite']});
                                },
                              ),
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
        ],
      ),
    );
  }
}
