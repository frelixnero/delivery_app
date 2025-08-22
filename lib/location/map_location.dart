import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapLocationPicker extends StatefulWidget {
  final Function(LatLng) onLocationSelected;
  const MapLocationPicker({super.key, required this.onLocationSelected});

  @override
  State<StatefulWidget> createState() => MapLocationPickerState();
}

class MapLocationPickerState extends State<MapLocationPicker> {
  GoogleMapController? _mapController;
  LatLng? selectedLocation;

  @override
  void initState() {
    super.initState();
    requestLocationPermission();
  }

  void requestLocationPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    } else if (permission == LocationPermission.deniedForever) {
      print(
        "Location permissions are permanently denied, we cannot request permissions.",
      );
    } else {
      getCurrentLocation();
    }
  }

  void getCurrentLocation() async {
    try {
      final LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      );
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
      );

      if (!mounted) return; // Ensure widget is still in the tree

      setState(() {
        selectedLocation = LatLng(position.latitude, position.longitude);
      });

      if (_mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(selectedLocation!, 14),
        );
      }
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Choose your delivery location",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
      content: Padding(
        padding: const EdgeInsets.all(0),
        child: SizedBox(
          width: double.maxFinite,
          height: MediaQuery.of(context).size.height * 0.8,
          child: Column(
            children: [
              Expanded(
                child: GoogleMap(
                  mapType: MapType.normal,
                  onMapCreated: (controller) {
                    _mapController = controller;
                  },
                  onTap: (latlng) {
                    setState(() {
                      selectedLocation = latlng;
                    });
                  },
                  markers:
                      selectedLocation != null
                          ? {
                            Marker(
                              markerId: MarkerId("selectedLocation"),
                              position: selectedLocation!,
                              infoWindow: InfoWindow(
                                title: "Select Location",
                                snippet: "Getting Your Location",
                              ),
                            ),
                          }
                          : {},
                  initialCameraPosition: CameraPosition(
                    target:
                        selectedLocation ??
                        LatLng(37.7749, -122.4194), // Example: San Francisco
                    zoom: 12,
                  ),

                  myLocationEnabled: true,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 10,
                ),
                child: FloatingActionButton(
                  onPressed: () {
                    if (selectedLocation != null) {
                      widget.onLocationSelected.call(selectedLocation!);
                    } else {
                      print("S O M E  E R R O R");
                    }
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.done),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
