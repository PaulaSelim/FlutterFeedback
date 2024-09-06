import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'review_list_page.dart';

class ReviewInputPage extends StatefulWidget {
  @override
  _ReviewInputPageState createState() => _ReviewInputPageState();
}

class _ReviewInputPageState extends State<ReviewInputPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _reviewController = TextEditingController();

  Box get _reviewsBox => Hive.box('reviewsBox');

  Future<void> _saveReview(String name, String email, String review) async {
    Map<String, String> reviewData = {
      'name': name,
      'email': email,
      'review': review
    };
    await _reviewsBox.add(reviewData);
  }

  void _submitReview() {
    String name = _nameController.text;
    String email = _emailController.text;
    String review = _reviewController.text;

    if (name.isNotEmpty && email.isNotEmpty && review.isNotEmpty) {
      _saveReview(name, email, review);
      _nameController.clear();
      _emailController.clear();
      _reviewController.clear();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Review Submitted!')));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('All fields are required!')));
    }
  }

  void _viewReviews() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ReviewListPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Submit a Review'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _reviewController,
              decoration: InputDecoration(labelText: 'Review'),
              maxLines: 5,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitReview,
              child: Text('Submit Review'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _viewReviews,
              child: Text('View All Reviews'),
            ),
          ],
        ),
      ),
    );
  }
}
