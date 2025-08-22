import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// ignore: must_be_immutable
class StoreLatlng extends ChangeNotifier {
  // get latitude
  LatLng? selectedLocation;

  Future<void> setLocation(LatLng? setLatLng) async {
    selectedLocation = setLatLng;
    notifyListeners();
  }

  LatLng? get mylatLing => selectedLocation;
}
