import 'dart:async';
import 'dart:collection';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:time_track/styles/colors/colors.dart';

class MapContainer extends StatefulWidget {
  final List<List<double>> zoneCoordinates;
  const MapContainer({Key? key, required this.zoneCoordinates})
      : super(key: key);

  @override
  State<MapContainer> createState() => _MapContainerState();
}

class _MapContainerState extends State<MapContainer> {
  final Set<Polygon> _polygon = HashSet<Polygon>();
  @override
  void initState() {
    super.initState();
    _polygon.add(Polygon(
      polygonId: const PolygonId('1'),
      points: widget.zoneCoordinates.map((e) => LatLng(e[0], e[1])).toList(),
      strokeWidth: 2,
      strokeColor: MyColors.primary,
      fillColor: MyColors.primary.withOpacity(0.15),
    ));
    safePrint(
        "🚀 ~ file: map_container.dart:50 ~ _MapContainerState ~ voidinitState ~ _polygon:  ${widget.zoneCoordinates.map((e) => LatLng(e[0], e[1])).toList()}");
  }

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  LatLng calculatePolygonCenter(List<LatLng> polygonVertices) {
    double centerX = 0.0;
    double centerY = 0.0;

    for (LatLng vertex in polygonVertices) {
      centerX += vertex.latitude;
      centerY += vertex.longitude;
    }

    centerX /= polygonVertices.length;
    centerY /= polygonVertices.length;

    return LatLng(centerX, centerY);
  }

  @override
  Widget build(BuildContext context) {
    final center = calculatePolygonCenter(_polygon.first.points);
    final lat = center.latitude;
    final lng = center.longitude;
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: CameraPosition(
        target: LatLng(lat, lng),
        zoom: 15,
      ),
      polygons: _polygon,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      onMapCreated: (GoogleMapController controller) {
        if (!_controller.isCompleted) {
          _controller.complete(controller);
        }
      },
    );
  }
}
