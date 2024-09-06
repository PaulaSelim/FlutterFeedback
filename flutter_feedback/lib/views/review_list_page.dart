import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ReviewListPage extends StatefulWidget {
  @override
  _ReviewListPageState createState() => _ReviewListPageState();
}

class _ReviewListPageState extends State<ReviewListPage> {
  Box get _reviewsBox => Hive.box('reviewsBox');

  // Function to delete a review at a specific index
  void _deleteReview(int index) async {
    await _reviewsBox.deleteAt(index);
    setState(() {}); // Update UI after deletion
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Review deleted')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Reviews'),
      ),
      body: FutureBuilder(
        future: _reviewsBox.isOpen ? null : Hive.openBox('reviewsBox'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (_reviewsBox.isEmpty) {
            return Center(child: Text('No reviews yet.'));
          }

          return ListView.builder(
            itemCount: _reviewsBox.length,
            itemBuilder: (context, index) {
              final review = _reviewsBox.getAt(index);
              return ListTile(
                title: Text(review['name']),
                subtitle: Text(
                    'Email: ${review['email']}\nReview: ${review['review']}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        // Confirm before deleting
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Delete Review"),
                              content: const Text(
                                  "Are you sure you want to delete this review?"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    _deleteReview(index);
                                  },
                                  child: Text("Delete"),
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
