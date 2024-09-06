import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'views/review_input_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter(); // Initialize Hive for Flutter
  await Hive.openBox('reviewsBox'); // Open Hive box to store reviews
  runApp(ReviewApp());
}

class ReviewApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Review App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ReviewInputPage(), // Start with the review input page
    );
  }
}
