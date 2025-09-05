import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TrackOrderPage extends StatefulWidget {
  final String orderId;
  const TrackOrderPage({super.key, required this.orderId});

  @override
  State<TrackOrderPage> createState() => _TrackOrderPageState();
}

class _TrackOrderPageState extends State<TrackOrderPage> {
  LatLng destination = LatLng(10.4240011, 9.5177209);
  LatLng deliveryDriverLocation = LatLng(8.4240011, 7.5177209);
  LatLng orderDeliveryAdress = LatLng(8.4240011, 7.5177209);
  GoogleMapController? googleMapController;
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueViolet,
  );
  double remainingDistance = 0.0;
  double totalDistance = 0.0;

  // firestore
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference orderTracking = FirebaseFirestore.instance.collection(
    'ordersTracking',
  );
  final CollectionReference orders = FirebaseFirestore.instance.collection(
    'orders',
  );

  // tracking timer
  late Timer _trackingTimer;

  Future<void> getOrderTracking() async {
    try {
      DocumentSnapshot snapshot = await orderTracking.doc(widget.orderId).get();
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

        // set new delvery driver loaction
        setState(() {
          deliveryDriverLocation = LatLng(data["latitude"], data["longitude"]);
        });

        // update camera
        googleMapController?.animateCamera(
          CameraUpdate.newLatLng(deliveryDriverLocation),
        );
        // calculate remaining distance
        calculateRemainigDistance();
      } else {
        print("Order ID: ${widget.orderId}");

        print("Document does not exist");
      }
    } catch (e) {
      print("Error fetching order tracking data: $e");
    }
  }

  void calculateRemainigDistance() {
    // get distance in meters
    double distance = Geolocator.distanceBetween(
      deliveryDriverLocation.latitude,
      deliveryDriverLocation.longitude,
      destination.latitude,
      destination.longitude,
    );

    // convert distance in Kilometers
    double distanceInKm = distance / 1000;

    setState(() {
      remainingDistance = distanceInKm;
    });

    print(remainingDistance);
  }

  // // create custom markeer
  // void addCustomMarker() {
  //   ImageConfiguration configuration = ImageConfiguration(
  //     size: Size(0, 0),
  //     devicePixelRatio: 5,
  //   );
  //   BitmapDescriptor.asset(
  //     configuration,
  //     "assets/animations/delivery_driver1.png",
  //   ).then((value) {
  //     print("H E I G H T ${value.height} ${value.imagePixelRatio}");
  //     setState(() {
  //       markerIcon = value;
  //     });
  //   });
  // }
  void addCustomMarker() async {
    try {
      final BitmapDescriptor customIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        "assets/animations/delivery_driver1.png",
      );

      print("Custom marker loaded.");

      setState(() {
        markerIcon = customIcon;
      });
    } catch (e) {
      print("Error loading custom marker: $e");
    }
  }

  // get current location
  void updateCurrentLocation(Position position) {
    setState(() {
      destination = LatLng(position.latitude, position.longitude);
    });
  }

  // get current location
  Future<void> getCurrentLocation() async {
    try {
      DocumentSnapshot snapshot = await orders.doc(widget.orderId).get();
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        print(
          "T H I S  IS  ORDER ID ADDREESS${data["latitude"]}, ${data["longitude"]}",
        );
        // set address delvery driver loactio
        setState(() {
          orderDeliveryAdress = LatLng(data["latitude"], data["longitude"]);
        });

        // update camera
        googleMapController?.animateCamera(
          CameraUpdate.newLatLng(deliveryDriverLocation),
        );
        // calculate remaining distance
        calculateRemainigDistance();
      } else {
        print("Order ID: ${widget.orderId}");

        print("Document does not exist");
      }
    } catch (e) {
      print("Error fetching order tracking data: $e");
    }
    // setState(() {
    //   destination = LatLng(position.latitude, position.longitude);
    // });
  }

  // initialize vars
  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    addCustomMarker();
    startTracking(widget.orderId);
    Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 10,
      ),
    ).listen((Position position) {
      updateCurrentLocation(position);
    });
  }

  void startTracking(String orderId) {
    _trackingTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      getOrderTracking();
    });
  }

  @override
  void dispose() {
    _trackingTimer.cancel();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Track Order"), centerTitle: true),
      body: Stack(
        children: [
          orderTracking.snapshots() == ConnectionState.waiting
              ? Center(child: CircularProgressIndicator(color: Colors.amber))
              : GoogleMap(
                mapType: MapType.hybrid,
                onMapCreated: (controller) {
                  googleMapController = controller;
                },
                initialCameraPosition: CameraPosition(
                  target: deliveryDriverLocation, // Example: San Francisco
                  zoom: 12,
                ),
                markers: {
                  // Users current location
                  Marker(
                    markerId: MarkerId("Destination"),
                    position: destination,
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueBlue,
                    ),

                    infoWindow: InfoWindow(
                      title: "Your Current Loaction",
                      snippet: "This is your current Location",
                    ),
                  ),

                  // Delivery Driver Current Location
                  Marker(
                    markerId: MarkerId("Delivery Driver"),
                    icon: markerIcon,
                    position: deliveryDriverLocation,
                    infoWindow: InfoWindow(
                      title: "Delivery driver location",
                      snippet: "delivery diver's current loaction",
                    ),
                  ),

                  // Address user enetered into receipt
                  Marker(
                    markerId: MarkerId("Your delivery address"),
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueOrange,
                    ),
                    position: orderDeliveryAdress,
                    infoWindow: InfoWindow(
                      title: "Receipt adress",
                      snippet: "Address you entered into receipt",
                    ),
                  ),
                },
              ),
          Positioned(
            top: 16,
            right: 0,
            left: 0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [
                    Colors.orange.shade100,
                    const Color.fromARGB(255, 117, 0, 251),
                  ],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
              ),
              padding: EdgeInsets.all(25),
              margin: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Distance left: ${remainingDistance.toStringAsFixed(2)}Km",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Icon(Icons.social_distance, size: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
