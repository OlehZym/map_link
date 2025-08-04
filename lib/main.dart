import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

void main() {
  runApp(const MapLinkApp());
}

class MapLinkApp extends StatelessWidget {
  const MapLinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Map link', style: TextStyle(fontSize: 22)),
      ),
      body: content(),
    );
  }

  Widget content() {
    return FlutterMap(
      options: MapOptions(
        initialCenter: LatLng(47.90620898132502, 33.47209458650657),
        initialZoom: 11,
        interactionOptions: const InteractionOptions(
          flags: ~InteractiveFlag.doubleTapZoom,
        ),
      ),
      children: [openStreetMapTileLayer],
    );
  }
}

TileLayer get openStreetMapTileLayer => TileLayer(
  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
  userAgentPackageName: 'dev.fleaflet.flutter_map.example',
);
