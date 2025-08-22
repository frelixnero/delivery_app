import 'package:delivery_app/location/store%20_latlng.dart';
import 'package:delivery_app/location/map_location.dart';
import 'package:delivery_app/models/resturant.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class MyCurrentLoaction extends StatelessWidget {
  MyCurrentLoaction({super.key});

  // text editing controllers
  final TextEditingController locationcontroller = TextEditingController();

  // get latitude
  LatLng? selectedLocation;

  Future<String> getAddressFromLatLng(LatLng latLng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        return "${place.street}, ${place.locality}, ${place.administrativeArea} ${place.postalCode}, ${place.country}";
      } else {
        return 'Address not found';
      }
    } catch (e) {
      print("Error getting address: $e");
      return 'Error getting address';
    }
  }

  Future<void> getAddress(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return MapLocationPicker(
          onLocationSelected: (LatLng userLocation) {
            selectedLocation = userLocation;
          },
        );
      },
    );
    String newAddress = await getAddressFromLatLng(selectedLocation!);
    context.read<Resturant>().updateAddress(newAddress);
    context.read<StoreLatlng>().setLocation(selectedLocation);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Deliver Now",
            style: TextStyle(
              color: Theme.of(context).colorScheme.tertiary,
              fontSize: 15,
            ),
          ),

          GestureDetector(
            onTap: () async {
              await showDialog(
                context: context,
                builder: (context) {
                  return MapLocationPicker(
                    onLocationSelected: (LatLng userLocation) {
                      selectedLocation = userLocation;
                    },
                  );
                },
              );
              // print(
              //   "L A T I T U D E:  ${selectedLocation?.latitude},  ${selectedLocation?.longitude}",
              // );
              context.read<StoreLatlng>().setLocation(selectedLocation);
              String newAddress = await getAddressFromLatLng(selectedLocation!);
              context.read<Resturant>().updateAddress(newAddress);
            },
            child: Row(
              children: [
                // address
                Consumer<Resturant>(
                  builder:
                      (context, resturant, child) => Flexible(
                        child: Text(
                          resturant.deliveryAddress.isEmpty
                              ? "Enter Address"
                              : resturant.deliveryAddress,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                ),

                // dropdown
                Icon(Icons.keyboard_double_arrow_down),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
