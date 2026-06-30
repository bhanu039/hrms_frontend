import 'package:flutter/material.dart';
import 'open_map.dart';
import '../../../core/widgets/location_get.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Location new")),
      body: Column(
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () async {
                
                final locationData = await LocationHelper.getCurrentLocation();
               
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MapScreen(
                      latitude: locationData?["latitude"],
                      longitude: locationData?["longitude"],
                    ),
                  ),
                );
              },
              child: const Text("Open Map"),
            ),
          ),
        ],
      ),
    );
  }
}
