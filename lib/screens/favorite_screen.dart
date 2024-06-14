import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
        title: Text("Favorite screen"),

      ),
      body: StreamBuilder<QuerySnapshot>(
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
                child: Image.network(post['image_url'], fit: BoxFit.cover),
                footer: GridTileBar(
                  backgroundColor: Colors.black54,
                  title: Text(post['name']),
                  subtitle: Text(post['type']),
                  trailing: IconButton(
                    icon: Icon(
                      post['isFavorite']? Icons.bookmark : Icons.bookmark_outline,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    onPressed: () async {
                      // Update status favorit di Firestore
                      await FirebaseFirestore.instance
                          .collection('posts')
                          .doc(post.id)
                          .update({'isFavorite':!post['isFavorite']});
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}