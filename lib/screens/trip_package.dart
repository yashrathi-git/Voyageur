import 'package:flutter/material.dart';
import 'package:infinite_carousel/infinite_carousel.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:voyageur/utils/colors.dart';

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
                    Card(
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
                    // Display images from imageUrls in an infinite carousel
                    InfiniteCarousel.builder(
                      itemCount: imageUrls!.length,
                      itemExtent: 150,
                      controller: _controller,
                      itemBuilder: (context, itemIndex, realIndex) {
                        final imageUrl = imageUrls![realIndex];
                        return Card(
                          elevation: 0, // No elevation
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          color: Colors.grey
                              .withOpacity(0.2), // Semi-transparent background
                          child: Image.network(imageUrl),
                        );
                      },
                    ),
                    SizedBox(height: 16),
                    // SmoothPageIndicator(
                    //   controller: _controller,
                    //   count: imageUrls!.length,
                    //   effect: ExpandingDotsEffect(
                    //     dotHeight: 12,
                    //     dotWidth: 12,
                    //     activeDotColor: Colors.blue,
                    //   ),
                    // ),
                  ],
                ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Handle the "Book Now" button action, e.g., open a web page
                  // using a URL launcher or navigate to the booking page.
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
}
