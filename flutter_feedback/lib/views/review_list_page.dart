import 'package:flutter/material.dart';
import 'package:flutter_feedback/views/review_input_page.dart';
import 'package:hive/hive.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.only(top: 100),
        children: [
          const ListTile(
            title: Text(
              'Menu :',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic, // Make the text italic
              ),
            ),
          ),
          ListTile(
            title: const Text('Submit a Review'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ReviewInputPage()),
              );
            },
          ),
          ListTile(
            title: const Text('View Reviews'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ReviewListPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class ReviewListPage extends StatefulWidget {
  const ReviewListPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ReviewListPageState createState() => _ReviewListPageState();
}

class _ReviewListPageState extends State<ReviewListPage> {
  Box get _reviewsBox => Hive.box('reviewsBox');

  // Function to delete a review at a specific index
  void _deleteReview(int index) async {
    await _reviewsBox.deleteAt(index);
    setState(() {}); // Update UI after deletion
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Review deleted')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Reviews'),
      ),
      drawer: const CustomDrawer(),
      body: FutureBuilder(
        future: _reviewsBox.isOpen ? null : Hive.openBox('reviewsBox'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_reviewsBox.isEmpty) {
            return const Center(child: Text('No reviews yet.'));
          }

          return ListView.builder(
            itemCount: _reviewsBox.length,
            itemBuilder: (context, index) {
              final review = _reviewsBox.getAt(index);
              return ListTile(
                title: Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text(review['name']),
                ),
                subtitle: Text(
                  'Email: ${review['email']}\nReview: ${review['review']}',
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        // Confirm before deleting
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Delete Review"),
                              content: const Text(
                                  "Are you sure you want to delete this review?"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    _deleteReview(index);
                                  },
                                  child: const Text("Delete"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
