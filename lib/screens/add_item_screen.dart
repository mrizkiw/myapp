import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddItemScreen extends StatefulWidget {
  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _locationController = TextEditingController();
  final _itemController = TextEditingController();
  List<String> locations = [];

  @override
  void initState() {
    super.initState();
    _fetchLocations();
  }

  Future<void> _fetchLocations() async {
    final response = await http.get(Uri.parse('https://colab-rizqi.et.r.appspot.com/api/locations'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
    setState(() {
      locations = List<String>.from(responseData['locations']); // Access the 'locations' list
    });
    }
  }

  Future<void> _addItem() async {
    final location = _locationController.text;
    final item = _itemController.text;
    if (location.isNotEmpty && item.isNotEmpty) {
      final response = await http.post(
        Uri.parse('https://colab-rizqi.et.r.appspot.com/api/add'),
        headers: {'Content-Type': 'application/json'}, // Set the content type to JSON
      body: jsonEncode({'location': location, 'item': item}), // Encode the data as JSON
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Item added')));
        _locationController.clear();
        _itemController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add item')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill all fields')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            DropdownButtonFormField<String>(
              value: locations.isNotEmpty ? locations.first : null,
              onChanged: (newValue) {
                _locationController.text = newValue!;
              },
              items: locations.map((location) {
                return DropdownMenuItem<String>(
                  value: location,
                  child: Text(location),
                );
              }).toList(),
              decoration: InputDecoration(labelText: 'Location'),
            ),
            TextField(
              controller: _locationController,
              decoration: InputDecoration(labelText: 'New Location'),
            ),
            TextField(
              controller: _itemController,
              decoration: InputDecoration(labelText: 'Item'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addItem,
              child: Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
