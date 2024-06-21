import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'location_detail_screen.dart';

class ViewLocationsScreen extends StatefulWidget {
  @override
  _ViewLocationsScreenState createState() => _ViewLocationsScreenState();
}

class _ViewLocationsScreenState extends State<ViewLocationsScreen> {
  List locations = [];

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
      locations = responseData['locations']; // Access the list of locations directly
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Locations'),
      ),
      body: ListView.builder(
        itemCount: locations.length,
        itemBuilder: (context, index) {
          return ListTile(
  title: Text(locations[index]), // Directly use the location string
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LocationDetailScreen(location: locations[index]), // Pass the location string
      ),
    );
  },

          );
        },
      ),
    );
  }
}
