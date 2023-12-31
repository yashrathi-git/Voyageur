import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:voyageur/screens/add_post_screen.dart';
import 'package:voyageur/screens/feed_screen.dart';
import 'package:voyageur/screens/profile_screen.dart';
import 'package:voyageur/screens/reel_screen.dart';
import 'package:voyageur/screens/search_screen.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  const FeedScreen(),
  const SearchScreen(),
  const AddPostScreen(),
  const ReelScreen(),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];
