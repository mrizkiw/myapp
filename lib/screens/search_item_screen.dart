import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchItemScreen extends StatefulWidget {
  @override
  _SearchItemScreenState createState() => _SearchItemScreenState();
}

class _SearchItemScreenState extends State<SearchItemScreen> {
  final _searchController = TextEditingController();
  List items = [];

  Future<void> _searchItems() async {
    final query = _searchController.text;
    if (query.isNotEmpty) {
      final response = await http.post(
        Uri.parse('https://colab-rizqi.et.r.appspot.com/api/search'),
        headers: {'Content-Type': 'application/json'}, // Add this header
      body: jsonEncode({'search_query': query}), // Encode the data as JSON
      );
      if (response.statusCode == 200) {
        setState(() {
          items = json.decode(response.body);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to search items')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter a search query')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _searchController,
              decoration: InputDecoration(labelText: 'Search'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _searchItems,
              child: Text('Search'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final result = items[index]; // Get the inner list for this result
    return ListTile(
      title: Text(result[2]), // Display the item (index 2)
      subtitle: Text(result[1]), // Display the location (index 1)
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
