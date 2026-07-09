import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:goexperts/core/services/api_client.dart';
import 'package:goexperts/core/widgets/top_message.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:goexperts/core/app_constants/app_color.dart';

import '../../../core/widgets/custom_text_field.dart';

class MapScreen extends StatefulWidget {
  final double latitude;
  final double longitude;

  const MapScreen({super.key, required this.latitude, required this.longitude});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  
  Future<void> openGoogleMaps() async {
  
    final url =
        "https://www.google.com/maps/search/?api=1&query=${widget.latitude},${widget.longitude}";

    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    
    final geofenceRadiusController = TextEditingController();
   
    final LatLng currentLocation = LatLng(widget.latitude, widget.longitude);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Live Location"),
        centerTitle: true,
        elevation: 0,
      ),
      body:  SafeArea(
    child: SingleChildScrollView(
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
                      color: AppColors.black.withOpacity(.1),
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
                            child:  Icon(
                              Icons.location_on,
                              color: AppColors.red,
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
                  color: AppColors.blue.shade50,
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
                         Icon(Icons.my_location, color: AppColors.blue),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "Latitude : ${widget.latitude}",
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                      ],
                    ),
        
                    const SizedBox(height: 8),
        
                    Row(
                      children: [
                         Icon(Icons.place, color: AppColors.red),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "Longitude : ${widget.longitude}",
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                     Row(
                      children: [
                         Icon(Icons.place, color: AppColors.red),
                        const SizedBox(width: 10),
                        Expanded(
                          child:CustomTextField(
                            label: "GeofenceRadius",
                            prefixIcon: Icon(Icons.radio_button_checked_sharp),
                            controller:geofenceRadiusController ,
                            keyboardType: TextInputType.number,
                            hintText: "Enter GeofenceRadius",
                            
        
                            
                          )
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
                        backgroundColor: AppColors.green,
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                  onPressed: () async {
                    try {
                      final response = await ApiClient.dio.put(
                        'api/company/settings/basic',
                        data: {'latitude': widget.latitude, 'longitude': widget.longitude,'geofenceRadius':geofenceRadiusController.text},
                      );
        
                      if (response.statusCode == 200||response.data["success"] == true) {
                        TopMessage.show(
                          context,
                          "Location updated successfully",
                          color: AppColors.green,
                        );
                      } else {
                        TopMessage.show(
                          context,
                          "Failed to update location ${response.data["message"]}",
                          color: AppColors.red,
                        );
                      }
                    } catch (e) {
                      TopMessage.show(
                        context,
                        "Error updating location: $e",
                        color: AppColors.red,
                      );
                    }
                  },
                  icon: const Icon(Icons.update),
                  label: const Text("update location"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.green,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              
            ],
          ),
        ),
      ),
    );
  }
}


