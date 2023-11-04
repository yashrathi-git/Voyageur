import 'package:flutter/cupertino.dart';

class PackageDetailsScreen extends StatelessWidget {
  final String packageName;
  final String packagePrice;
  final String packageLink;

  const PackageDetailsScreen({
    Key? key,
    required this.packageName,
    required this.packagePrice,
    required this.packageLink,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Package Name: $packageName',
            style: TextStyle(fontSize: 20),
          ),
          Text(
            'Package Price: \$${packagePrice}',
            style: TextStyle(fontSize: 18),
          ),
          Text(
            'Package Link: $packageLink',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
