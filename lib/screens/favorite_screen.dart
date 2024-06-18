import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petlv/screens/profile_screen.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
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
              MaterialPageRoute(
                  builder: (context) => const ProfileScreen()), // ProfilScreen
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
            child: const Padding(
              padding: EdgeInsets.all(10.0),
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
                      decoration: InputDecoration(
                          labelText: 'Search...',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.search)),
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
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: snapshot.data!.docs.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.6,
                    mainAxisSpacing: 8.0,
                    crossAxisSpacing: 8.0,
                  ),
                  itemBuilder: (context, index) {
                    final post = snapshot.data!.docs[index];
                    return GridTile(
                      child:
                          Image.network(post['image_url'], fit: BoxFit.cover),
                      footer: GridTileBar(
                        backgroundColor: Colors.black54,
                        title: Text(post['name']),
                        subtitle: Text(post['type']),
                        trailing: IconButton(
                          icon: Icon(
                            post['isFavorite']
                                ? Icons.bookmark
                                : Icons.bookmark_outline,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          onPressed: () async {
                            // Update status favorit di Firestore
                            await FirebaseFirestore.instance
                                .collection('posts')
                                .doc(post.id)
                                .update({'isFavorite': !post['isFavorite']});
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
