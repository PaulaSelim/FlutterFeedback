import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'review_list_page.dart';

class ReviewInputPage extends StatefulWidget {
  const ReviewInputPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
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
          .showSnackBar(const SnackBar(content: Text('Review Submitted!')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('All fields are required!')));
    }
  }

  void _viewReviews() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ReviewListPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Submit a Review'),
      ),
      drawer: const CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _reviewController,
              decoration: const InputDecoration(labelText: 'Review'),
              maxLines: 5,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitReview,
              child: const Text('Submit Review'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _viewReviews,
              child: const Text('View All Reviews'),
            ),
          ],
        ),
      ),
    );
  }
}
