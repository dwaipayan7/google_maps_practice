import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapFlutter extends StatefulWidget {
  const GoogleMapFlutter({super.key});

  @override
  State<GoogleMapFlutter> createState() => _GoogleMapFlutterState();
}

class _GoogleMapFlutterState extends State<GoogleMapFlutter> {
  LatLng myCurrentLocation = const LatLng(23.6107, 88.3849);
  BitmapDescriptor customIcon = BitmapDescriptor.defaultMarker;

  late GoogleMapController googleMapController;
  Set<Marker> marker = {};

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
        myLocationEnabled: false,
        markers: marker,
        onMapCreated: (controller) => googleMapController = controller,
        initialCameraPosition: CameraPosition(
          target: myCurrentLocation,
          zoom: 15,
        ),
        // markers: {
        //   Marker(
        //     markerId: const MarkerId("current_location"),
        //     position: myCurrentLocation,
        //     draggable: true,
        //     onDragEnd: (value) => setState(() => myCurrentLocation = value),
        //     infoWindow: const InfoWindow(
        //       title: "Custom Marker",
        //       snippet: "Drag me to update location",
        //     ),
        //     // icon: customIcon,
        //   ),
        // },
        // myLocationEnabled: true,
        // myLocationButtonEnabled: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async => await _updateCurrentLocation(),
        child: const Icon(Icons.my_location),
      ),
    );
  }

  Future<void> _updateCurrentLocation() async {
    try {
      Position position = await _getCurrentPosition();
      LatLng newPosition = LatLng(position.latitude, position.longitude);

      googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: newPosition, zoom: 15),
        ),
      );

      marker.clear();
      marker.add(
        Marker(
          markerId: const MarkerId("This is my location"),
          position: newPosition,
        ),
      );
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  Future<Position> _getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error("Location services are disabled.");
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Location permission denied.");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error("Location permission permanently denied.");
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}
