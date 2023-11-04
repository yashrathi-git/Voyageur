import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:voyageur/providers/user_provider.dart';
import 'package:voyageur/resources/firestore_methods.dart';
import 'package:voyageur/utils/colors.dart';
import 'package:voyageur/utils/utils.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  List<Uint8List>? _files;
  bool isLoading = false;
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _packageNameController = TextEditingController();
  final TextEditingController _packageLinkController = TextEditingController();
  final TextEditingController _packagePriceController = TextEditingController();
  bool _isPackageSelected = false;
  DateTime? _selectedDate;

  Future<void> _selectImage(BuildContext parentContext) async {
    return showModalBottomSheet(
      backgroundColor: const Color(0x00ff0000),
      context: parentContext,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(20), // Adjust the radius as needed
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.bottomLeft,
                colors: [
                  Color.fromARGB(243, 0, 0, 0),
                  Color.fromARGB(243, 0, 0, 0),
                ],
              ),
              borderRadius: BorderRadius.circular(20), // Same radius as above
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SimpleDialogOption(
                  child: ListTile(
                    leading: Icon(
                      Icons.camera,
                      color: Colors.blueAccent,
                      size: 40,
                    ),
                    title: const Text(
                      'Take a photo',
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () async {
                      Navigator.pop(context);
                      Uint8List file = await pickImage(ImageSource.camera);
                      setState(() {
                        _file = file;
                      });
                    },
                  ),
                ),
                SimpleDialogOption(
                  child: ListTile(
                    leading: const Icon(
                      Icons.photo,
                      color: Colors.greenAccent,
                      size: 40,
                    ),
                    title: const Text(
                      'Choose from Gallery',
                      style: TextStyle(
                        color: Colors.greenAccent,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () async {
                      Navigator.pop(context);
                      Uint8List file = await pickImage(ImageSource.gallery);
                      setState(() {
                        _file = file;
                      });
                    },
                  ),
                ),
                SimpleDialogOption(
                  child: ListTile(
                    leading: Icon(
                      Icons.photo_library_outlined,
                      color: Colors.pinkAccent,
                      size: 40,
                    ),
                    title: const Text(
                      'Choose Multiple Images',
                      style: TextStyle(
                        color: Colors.pinkAccent,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () async {
                      Navigator.pop(context);
                      List<Uint8List> files = await pickMultipleImages();
                      setState(() {
                        _files = files;
                        _file = files[0];
                      });
                    },
                  ),
                ),
                SimpleDialogOption(
                  child: ListTile(
                    leading: Icon(
                      Icons.cancel,
                      size: 40,
                      color: Colors.redAccent,
                    ),
                    title: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void postImage(String uid, String username, String profImage) async {
    setState(() {
      isLoading = true;
    });
    // start the loading
    try {
      // upload to storage and db
      String res = await FireStoreMethods().uploadPost(
          _descriptionController.text,
          _file!,
          uid,
          username,
          profImage,
          _files,
          _locationController.text,
          _isPackageSelected,
          _packageNameController.text,
          _packageLinkController.text,
          _packagePriceController.text,
          _selectedDate);
      if (res == "success") {
        setState(() {
          isLoading = false;
        });
        if (context.mounted) {
          showSnackBar(
            context,
            'Posted!',
          );
        }
        clearImage();
      } else {
        if (context.mounted) {
          showSnackBar(context, res);
        }
      }
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return Stack(
      children: <Widget>[
        // Positioned image at the top center
        Padding(
          padding: const EdgeInsets.only(top: 30),
          // padding: const EdgeInsets.only(top: 100.0),
          child: Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/final.png', // replace with your image path
              fit: BoxFit.cover,
            ),
          ),
        ),
        Padding(padding: const EdgeInsets.only(top: 100.0)),

        // Your existing widgets
        _file == null
            ? Center(
                child: IconButton(
                  iconSize: 60,
                  icon: const Icon(
                    Icons.upload,
                  ),
                  onPressed: () => _selectImage(context),
                ),
              )
            : buildAddPhotosForm(userProvider, context),
      ],
    );
  }

  Scaffold buildAddPhotosForm(UserProvider userProvider, BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: clearImage,
        ),
        title: const Text(
          'Post to',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => postImage(
              userProvider.getUser.uid,
              userProvider.getUser.username,
              userProvider.getUser.photoUrl,
            ),
            child: const Text(
              "Post",
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          )
        ],
      ),
      // POST FORM
      body: Column(
        children: <Widget>[
          isLoading
              ? const LinearProgressIndicator()
              : const SizedBox(), // Use SizedBox instead of Padding
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CircleAvatar(
                backgroundImage: NetworkImage(
                  userProvider.getUser.photoUrl,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                child: TextField(
                  controller: _descriptionController,
                  maxLines: 8,
                  decoration: const InputDecoration(
                    hintText: "Write a caption...",
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(
                height: 45.0,
                width: 45.0,
                child: AspectRatio(
                  aspectRatio: 487 / 451,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        alignment: FractionalOffset.topCenter,
                        image: MemoryImage(_file!),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Divider(),
          TextField(
            controller: _locationController,
            decoration: const InputDecoration(labelText: 'Location'),
          ),
          Row(
            children: [
              Checkbox(
                value: _isPackageSelected,
                onChanged: (value) {
                  setState(() {
                    _isPackageSelected = value!;
                  });
                },
              ),
              const Text('Select Package'),
            ],
          ),
          if (_isPackageSelected)
            Column(
              children: [
                TextField(
                  controller: _packageNameController,
                  decoration: const InputDecoration(labelText: 'Package Name'),
                ),
                TextField(
                  controller: _packageLinkController,
                  decoration: const InputDecoration(labelText: 'Package Link'),
                ),
                TextField(
                  controller: _packagePriceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Price'),
                ),
                ElevatedButton(
                  onPressed: () => _selectDate(context),
                  child: const Text('Select Date'),
                ),
                if (_selectedDate != null)
                  Text(
                    'Selected Date: ${DateFormat('MM/dd/yyyy').format(_selectedDate!)}',
                  ),
              ],
            ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime pickedDate = (await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    ))!;
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }
}
