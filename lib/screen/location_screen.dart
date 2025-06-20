import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:latlong2/latlong.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  LatLng _childLocation = LatLng(0, 0);

  final DatabaseReference _locationRef = FirebaseDatabase.instance.ref(
    'location',
  );

  late final MapController _mapController;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();

    _locationRef.onValue.listen((event) {
      final data = event.snapshot.value as Map;
      double lat = double.parse(data['latitude'].toString());
      double lng = double.parse(data['longitude'].toString());

      setState(() {
        _childLocation = LatLng(lat, lng);
        _mapController.move(_childLocation, 16);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Child Location",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(initialCenter: _childLocation, initialZoom: 16),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: const ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: _childLocation,
                width: 60,
                height: 60,
                child: const Icon(
                  Icons.location_pin,
                  color: Colors.red,
                  size: 40,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}