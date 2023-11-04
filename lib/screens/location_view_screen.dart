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
  List<String> imageUrls = [];

  @override
  void initState() {
    super.initState();
    fetchImageUrls();
  }

  Future<void> fetchImageUrls() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('posts')
        .where('location', isEqualTo: widget.location)
        .get();

    for (QueryDocumentSnapshot document in querySnapshot.docs) {
      final List<String> urls = List<String>.from(document['files']);
      imageUrls.addAll(urls);
    }

    setState(() {
      // State has changed, and imageUrls array is populated, build the UI.
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.location),
      ),
      body: GridView.builder(
        shrinkWrap: true,
        itemCount: imageUrls.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 3,
          mainAxisSpacing: 1.0,
          childAspectRatio: 1,
        ),
        itemBuilder: (context, index) {
          String imageUrl = imageUrls[index];

          return SizedBox(
            width: 200, // Adjust the width as needed
            height: 200, // Adjust the height as needed
            child: Image(
              image: NetworkImage(imageUrl),
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }
}
