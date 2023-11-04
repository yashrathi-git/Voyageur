import 'package:flutter/material.dart';
import 'package:infinite_carousel/infinite_carousel.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart'; // Import the url_launcher package
import 'package:voyageur/utils/colors.dart';
import 'package:voyageur/widgets/image_carosel.dart';

class PackageDetailsScreen extends StatelessWidget {
  final String packageName;
  final String packagePrice;
  final String packageLink;
  final List<String>? imageUrls; // List of image URLs

  final InfiniteScrollController _controller = InfiniteScrollController();

  PackageDetailsScreen({
    Key? key,
    required this.packageName,
    required this.packagePrice,
    required this.packageLink,
    this.imageUrls, // Initialize imageUrls
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text(this.packageName),
        centerTitle: false,
      ),
      backgroundColor:
          Theme.of(context).scaffoldBackgroundColor, // Set background color
      body: Container(
        color: mobileBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (imageUrls != null)
                Column(
                  children: [
                    ImageCarousel(
                      imageUrls: imageUrls!,
                      autoScroll: true,
                    ),
                    // Show the package title
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      color: Colors.grey.withOpacity(0.2),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16),
                        title: Text(
                          'Name',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          '$packageName',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    // Package price card
                    Row(
                      children: [
                        Expanded(
                          flex:
                              7, // Adjust the flex values to control the card widths
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            color: Colors.grey.withOpacity(0.2),
                            child: ListTile(
                              contentPadding: EdgeInsets.all(16),
                              title: Text(
                                'Package Price',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                '₹ $packagePrice',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex:
                              3, // Adjust the flex values to control the card widths
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            color: Colors.green, // Green background
                            child: ListTile(
                              contentPadding: EdgeInsets.all(16),
                              title: RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: '10%',
                                      style: TextStyle(
                                        fontSize:
                                            30, // Increase the font size for "10%"
                                        color: Colors.white, // White text color
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' voya-coins',
                                      style: TextStyle(
                                        color: Colors.white, // White text color
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Handle the "Book Now" button action by launching the URL
                  _launchURL(packageLink);
                },
                child: Text('Book Now'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue, // Button color
                  onPrimary: Colors.white, // Text color
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to open the URL
  _launchURL(String url) async {
    Uri ur = Uri.parse(url);
    if (!await launchUrl(ur)) {
      throw Exception('Could not launch $ur');
    }
  }
}
