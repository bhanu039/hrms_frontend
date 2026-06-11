import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:goexperts/core/services/api_client.dart';
import 'package:goexperts/core/widgets/top_message.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class MapScreen extends StatelessWidget {
  final double latitude;
  final double longitude;

  const MapScreen({super.key, required this.latitude, required this.longitude});

  Future<void> openGoogleMaps() async {
    final url =
        "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude";

    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final LatLng currentLocation = LatLng(latitude, longitude);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Live Location"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// MAP CARD
            Container(
              height: 280,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: currentLocation,
                    initialZoom: 16,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.myapp.goHrms',
                    ),

                    MarkerLayer(
                      markers: [
                        Marker(
                          point: currentLocation,
                          width: 80,
                          height: 80,
                          child: const Icon(
                            Icons.location_on,
                            color: Colors.red,
                            size: 50,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// LOCATION INFO
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Current Coordinates",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      const Icon(Icons.my_location, color: Colors.blue),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Latitude : $latitude",
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      const Icon(Icons.place, color: Colors.red),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Longitude : $longitude",
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            /// ACTION BUTTONS
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: openGoogleMaps,
                    icon: const Icon(Icons.map),
                    label: const Text("Open Maps"),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text("Refresh"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () async {
                  try {
                    final response = await ApiClient.dio.put(
                      '/company/settings/basic',
                      data: {'latitude': latitude, 'longitude': longitude},
                    );

                    if (response.statusCode == 200||response.data["success"] == true) {
                      TopMessage.show(
                        context,
                        "Location updated successfully",
                        color: Colors.green,
                      );
                    } else {
                      TopMessage.show(
                        context,
                        "Failed to update location ${response.data["message"]}",
                        color: Colors.red,
                      );
                    }
                  } catch (e) {
                    TopMessage.show(
                      context,
                      "Error updating location: $e",
                      color: Colors.red,
                    );
                  }
                },
                icon: const Icon(Icons.update),
                label: const Text("update location"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
