import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';

void main() {
  runApp(const MapLinkApp());
}

class MapLinkApp extends StatelessWidget {
  const MapLinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Map Link', home: const MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  final logger = Logger();
  late final MapController _mapController = MapController();
  LatLng? _currentPosition;
  double zoom = 15.0;
  bool isLoading = true;

  StreamSubscription<Position>? _positionStream;

  String mapUrl =
      'https://api.maptiler.com/maps/streets/{z}/{x}/{y}.png?key=JHC4LkWdMJFtt48jFpmC';

  @override
  void initState() {
    super.initState();
    _startTrackingLocation();
  }

  void _startTrackingLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.whileInUse &&
            permission != LocationPermission.always) {
          setState(() => isLoading = false);
          return;
        }
      }

      // Настройки отслеживания
      const locationSettings = LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 1, // обновлять при сдвиге на 5 метров
      );

      _positionStream = Geolocator.getPositionStream(
        locationSettings: locationSettings,
      ).listen((Position position) {
        final latLng = LatLng(position.latitude, position.longitude);
        setState(() {
          _currentPosition = latLng;
          isLoading = false;
        });

        // Чтобы карта всегда следила за позицией
        //_mapController.move(latLng, zoom);
      });
    } catch (e) {
      setState(() => isLoading = false);
      debugPrint('Error getting location: $e');
    }
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }

  void openAddWarningWindow(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return LayoutBuilder(
          builder: (context, constraints) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: constraints.maxWidth),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Що ви бачите?', style: TextStyle(fontSize: 20)),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(15),
                                  backgroundColor: const Color.fromARGB(
                                    255,
                                    255,
                                    17,
                                    0,
                                  ).withAlpha(140),
                                ),
                                onPressed: () {},
                                child: Image.asset(
                                  'assets/icons/traffic.png',
                                  width: 44,
                                  height: 44,
                                ),
                              ),
                              Text('Затор', style: TextStyle(fontSize: 12)),
                            ],
                          ),
                          Column(
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(15),
                                  backgroundColor: const Color.fromARGB(
                                    255,
                                    0,
                                    183,
                                    255,
                                  ).withAlpha(180),
                                ),
                                onPressed: () {},
                                child: Image.asset(
                                  'assets/icons/police.png',
                                  width: 44,
                                  height: 44,
                                ),
                              ),
                              Text('Поліція', style: TextStyle(fontSize: 12)),
                            ],
                          ),
                          Column(
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(15),
                                  backgroundColor: Colors.grey.withAlpha(180),
                                ),
                                onPressed: () {},
                                child: Transform.translate(
                                  offset: const Offset(0, -2.5),
                                  child: Image.asset(
                                    'assets/icons/crash.png',
                                    width: 48,
                                    height: 48,
                                  ),
                                ),
                              ),
                              Text('Аварія', style: TextStyle(fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(15),
                                  backgroundColor: const Color.fromARGB(
                                    255,
                                    255,
                                    208,
                                    0,
                                  ).withAlpha(180),
                                ),
                                onPressed: () {},
                                child: Transform.translate(
                                  offset: const Offset(0, -2.5),
                                  child: Image.asset(
                                    'assets/icons/warning.png',
                                    width: 48,
                                    height: 48,
                                  ),
                                ),
                              ),
                              Text('Небезпека', style: TextStyle(fontSize: 12)),
                            ],
                          ),
                          Column(
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(15),
                                  backgroundColor: const Color.fromARGB(
                                    255,
                                    255,
                                    123,
                                    0,
                                  ).withAlpha(180),
                                ),
                                onPressed: () {},
                                child: Image.asset(
                                  'assets/icons/blocked_road.png',
                                  width: 48,
                                  height: 48,
                                ),
                              ),
                              Text(
                                'Перекриття',
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(15),
                                  backgroundColor: const Color.fromARGB(
                                    255,
                                    255,
                                    145,
                                    0,
                                  ).withAlpha(190),
                                ),
                                onPressed: () {},
                                child: Image.asset(
                                  'assets/icons/blocked_traffic_lane.png',
                                  width: 48,
                                  height: 48,
                                ),
                              ),
                              Text(
                                'Перекрита\n    смуга',
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(15),
                                  backgroundColor: const Color.fromARGB(
                                    255,
                                    55,
                                    0,
                                    255,
                                  ).withAlpha(180),
                                ),
                                onPressed: () {},
                                child: Transform.translate(
                                  offset: const Offset(0, -2.5),
                                  child: Image.asset(
                                    'assets/icons/bad_weather.png',
                                    width: 48,
                                    height: 48,
                                  ),
                                ),
                              ),
                              Text(
                                'Погана погода',
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(15),
                                  backgroundColor: const Color.fromARGB(
                                    255,
                                    214,
                                    214,
                                    214,
                                  ),
                                ),
                                onPressed: () {},
                                child: Transform.translate(
                                  offset: const Offset(0, -2.5),
                                  child: Image.asset(
                                    'assets/icons/map_error.png',
                                    width: 48,
                                    height: 48,
                                  ),
                                ),
                              ),
                              Text(
                                'Помилка мапи',
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(15),
                                  backgroundColor: const Color.fromARGB(
                                    255,
                                    255,
                                    0,
                                    0,
                                  ).withAlpha(180),
                                ),
                                onPressed: () {},
                                child: Transform.translate(
                                  offset: const Offset(0, 0),
                                  child: Image.asset(
                                    'assets/icons/sos.png',
                                    width: 48,
                                    height: 48,
                                  ),
                                ),
                              ),
                              Text('Sos', style: TextStyle(fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _goToMyLocation() async {
    if (_currentPosition != null) {
      _mapController.move(_currentPosition!, zoom);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Map link', style: TextStyle(fontSize: 22)),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: const LatLng(1.2878, 103.8666),
              initialZoom: zoom,
              interactionOptions: const InteractionOptions(
                flags: ~InteractiveFlag.doubleTapZoom,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: mapUrl,
                userAgentPackageName: 'com.example.map_link',
              ),
              if (_currentPosition != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      width: 50,
                      height: 50,
                      point: _currentPosition!,
                      child: const Icon(
                        Icons.my_location,
                        color: Colors.blue,
                        size: 24,
                      ),
                    ),
                  ],
                ),
            ],
          ),

          if (isLoading) const Center(child: CircularProgressIndicator()),

          Positioned(
            bottom: 15,
            left: 15,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(20),
              ),
              onPressed: _goToMyLocation,
              child: const Icon(
                Icons.my_location,
                color: Colors.blue,
                size: 25,
              ),
            ),
          ),
          Positioned(
            bottom: 15,
            right: 15,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(4),
                backgroundColor: Colors.white,
              ),
              onPressed: () => openAddWarningWindow(context),
              child: Transform.translate(
                offset: const Offset(0, -4),
                child: Image.asset(
                  'assets/icons/add_warning.png',
                  width: 64,
                  height: 64,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
