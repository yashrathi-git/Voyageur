import 'package:cloud_firestore/cloud_firestore.dart';
// Post post = Post(
//         description: description,
//         uid: uid,
//         username: username,
//         likes: [],
//         postId: postId,
//         datePublished: DateTime.now(),
//         postUrl: photoUrl,
//         profImage: profImage,
//         files: photoUrls,
//         isMultipleImages: (files != null && files.length > 0) ? true : false,
//         location: location,
//         isPackageSelected: isPackageSelected,
//         packageName: packageName,
//         packageLink: packageLink,
//         packagePrice: packagePrice,
//         date: date,

//       );
class Post {
  final String description;
  final String uid;
  final String username;
  final likes;
  final String postId;
  final DateTime datePublished;
  final String postUrl;
  final String profImage;
  final List<String>? files;
  final bool? isMultipleImages;
  final String? location;
  final bool? isPackageSelected;
  final String? packageName;
  final String? packageLink;
  final String? packagePrice;
  final DateTime? date;

  const Post({
    required this.description,
    required this.uid,
    required this.username,
    required this.likes,
    required this.postId,
    required this.datePublished,
    required this.postUrl,
    required this.profImage,
    this.files,
    this.isMultipleImages,
    this.location,
    this.isPackageSelected,
    this.packageName,
    this.packageLink,
    this.packagePrice,
    this.date,
  });

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
      description: snapshot["description"],
      uid: snapshot["uid"],
      likes: snapshot["likes"],
      postId: snapshot["postId"],
      datePublished: snapshot["datePublished"].toDate(),
      username: snapshot["username"],
      postUrl: snapshot['postUrl'],
      profImage: snapshot['profImage'],
      files: snapshot['files'] != null
          ? List<String>.from(snapshot['files'])
          : null,
      isMultipleImages: snapshot['isMultipleImages'] ?? false,
      location: snapshot['location'],
      isPackageSelected: snapshot['isPackageSelected'],
      packageName: snapshot['packageName'],
      packageLink: snapshot['packageLink'],
      packagePrice: snapshot['packagePrice'],
      date: (snapshot['date'] != null) ? snapshot['date'].toDate() : null,
    );
  }

  Map<String, dynamic> toJson() => {
        "description": description,
        "uid": uid,
        "likes": likes,
        "username": username,
        "postId": postId,
        "datePublished": datePublished,
        'postUrl': postUrl,
        'profImage': profImage,
        'files': files,
        'isMultipleImages': isMultipleImages,
        'location': location,
        'isPackageSelected': isPackageSelected,
        'packageName': packageName,
        'packageLink': packageLink,
        'packagePrice': packagePrice,
        'date': date,
      };
}
