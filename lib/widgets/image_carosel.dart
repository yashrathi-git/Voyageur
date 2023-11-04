import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'dart:async';

class ImageCarousel extends StatefulWidget {
  final List<String> imageUrls;
  final bool autoScroll;

  ImageCarousel({required this.imageUrls, this.autoScroll = false});

  @override
  _ImageCarouselState createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  PageController _pageController = PageController();
  int _currentPage = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    if (widget.autoScroll) {
      _startAutoScroll();
    }

    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_currentPage == widget.imageUrls.length - 1) {
        _currentPage = 0;
        _pageController.animateToPage(
          0,
          duration: Duration(milliseconds: 500),
          curve: Curves.linear,
        );
      } else {
        _pageController.nextPage(
          duration: Duration(milliseconds: 500),
          curve: Curves.linear,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.35,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.imageUrls.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    widget.imageUrls[index],
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SmoothPageIndicator(
            controller: _pageController, // PageController
            count: widget.imageUrls.length,
            effect: WormEffect(
              activeDotColor: Color.fromARGB(
                  255, 82, 82, 82), // Make the active dot transparent
              dotColor: Colors.white, // Set inactive indicator color to white
              dotHeight: 6.0, // Set a smaller dot height
              dotWidth: 6.0, // Set a smaller dot width
              spacing: 8.0, // Spacing between dots
            ),
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when disposing of the widget
    _pageController.dispose();
    super.dispose();
  }
}
