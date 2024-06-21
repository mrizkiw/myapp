import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationDetailScreen extends StatelessWidget {
  final String location;

  LocationDetailScreen({required this.location});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location: $location'),
      ),
      body: FutureBuilder(
        future: http.get(Uri.parse('https://colab-rizqi.et.r.appspot.com/api/locations/$location')),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            final Map<String, dynamic> data = json.decode(snapshot.data!.body);
      final List<String> items = data['items'].cast<String>(); // Correctly cast to List<String>
      return ListView.builder(
        itemCount: items.length
,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(items[index]),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
