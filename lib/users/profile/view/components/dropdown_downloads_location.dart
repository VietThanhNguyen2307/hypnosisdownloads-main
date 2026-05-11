import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DropdownDownloadsLocation extends StatefulWidget {
  const DropdownDownloadsLocation({super.key});

  @override
  DropdownDownloadsLocationState createState() =>
      DropdownDownloadsLocationState();
}

class DropdownDownloadsLocationState extends State<DropdownDownloadsLocation> {
  String _selectedLocation = 'External storage';

  @override
  void initState() {
    super.initState();
    _loadSavedLocation();
  }

  Future<void> _loadSavedLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String savedLocation =
        prefs.getString('downloads_location') ?? 'External storage';
    setState(() {
      _selectedLocation = savedLocation;
    });
  }

  Future<void> _saveSelectedLocation(String location) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('downloads_location', location);
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: 'Downloads location',
      ),
      value: _selectedLocation,
      onChanged: (String? value) {
        setState(() {
          _selectedLocation = value ?? 'External storage';
          _saveSelectedLocation(_selectedLocation);
        });
      },
      items: <String>['Internal storage', 'External storage']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
