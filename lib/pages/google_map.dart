import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapFlutter extends StatefulWidget {
  const GoogleMapFlutter({super.key});

  @override
  State<GoogleMapFlutter> createState() => _GoogleMapFlutterState();
}

class _GoogleMapFlutterState extends State<GoogleMapFlutter> {
  LatLng myCurrentLocation = const LatLng(23.6107, 88.3849);
  BitmapDescriptor customIcon = BitmapDescriptor.defaultMarker;

  @override
  void initState() {
    super.initState();
    // customMarker();
  }

  // void customMarker() async {
  //   try {
  //     final icon = await BitmapDescriptor.fromAssetImage(
  //       const ImageConfiguration(size: Size(10, 10)),
  //       'assets/marker2.png',
  //     );
  //     setState(() => customIcon = icon);
  //   } catch (e) {
  //     print("Error loading custom marker: $e");
  //     // Fallback to default marker
  //     setState(() => customIcon = BitmapDescriptor.defaultMarker);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: myCurrentLocation,
          zoom: 15,
        ),
        markers: {
          Marker(
            markerId: const MarkerId("current_location"),
            position: myCurrentLocation,
            draggable: true,
            onDragEnd: (value) => setState(() => myCurrentLocation = value),
            infoWindow: const InfoWindow(
              title: "Custom Marker",
              snippet: "Drag me to update location",
            ),
            // icon: customIcon,
          ),
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }
}