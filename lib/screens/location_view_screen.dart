import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/post.dart';

class PostService {
  Future<List<Post>> getPostsByLocation(String location) async {
    List<Post> posts = [];

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(
            'posts') // Replace 'posts' with your Firestore collection name
        .where('location', isEqualTo: location)
        .get();

    for (QueryDocumentSnapshot document in querySnapshot.docs) {
      posts.add(Post.fromSnap(document));
    }

    return posts;
  }
}

class LocationViewScreen extends StatefulWidget {
  final String location;

  const LocationViewScreen({Key? key, required this.location})
      : super(key: key);

  @override
  _LocationViewScreenState createState() => _LocationViewScreenState();
}

class _LocationViewScreenState extends State<LocationViewScreen> {
  List<Post> posts = [];
  List<String> imageUrls = [];

  @override
  void initState() {
    super.initState();
    fetchPostsByLocation();
  }

  Future<void> fetchPostsByLocation() async {
    List<Post> result = await PostService().getPostsByLocation(widget.location);
    setState(() {
      posts = result;
      // Extract imageUrls from posts and accumulate them
      for (var post in posts) {
        if (post.files != null) {
          imageUrls.addAll(post.files!);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.location),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('posts')
            .where('location', isEqualTo: widget.location)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return GridView.builder(
            shrinkWrap: true,
            itemCount: (snapshot.data! as dynamic).docs.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 5,
              mainAxisSpacing: 1.5,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              DocumentSnapshot snap = (snapshot.data! as dynamic).docs[index];

              return SizedBox(
                child: Image(
                  image: NetworkImage(snap['postUrl']),
                  fit: BoxFit.cover,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
