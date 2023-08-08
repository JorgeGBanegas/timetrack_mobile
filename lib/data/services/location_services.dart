import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:time_track/data/models/scheduleAndAssistence.dart';
import 'package:time_track/data/services/auth_services.dart';
import 'package:time_track/api.dart';
import 'package:http/http.dart' as http;

class LocationServices {
  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<List<List<double>>> getAssignZone() async {
    try {
      Map<String, String> tokenData = await AuthService().getToken();
      final infoUser = await AuthService().getUserInfo();
      String token = tokenData['token']!;
      String email = infoUser['email'];

      Map<String, String> header = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await http.get(
        Uri.parse('${Api.urlGeofencing}/assigned-zones/employee/$email'),
        headers: header,
      );
      final body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final coordinates = body['zoneId']['coordinates'];
        return convertCoordinates(coordinates);
      } else {
        throw Exception(body['message']);
      }
    } catch (e) {
      rethrow;
    }
  }

  List<List<double>> convertCoordinates(List<dynamic> coordinates) {
    List<List<double>> coordinatesList = [];
    for (var element in coordinates) {
      List<double> coordinate = [];
      coordinate.add(element[0]);
      coordinate.add(element[1]);
      coordinatesList.add(coordinate);
    }
    safePrint('sadasjdaskjdkasjdkasj: ${coordinatesList.toString()}');
    return coordinatesList;
  }

  Future<ScheduleAndAssistence> getScheduleAndAssistence() async {
    try {
      Map<String, String> tokenData = await AuthService().getToken();
      final infoUser = await AuthService().getUserInfo();
      String token = tokenData['token']!;
      String email = infoUser['email'];

      Map<String, String> header = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await http.get(
        Uri.parse('${Api.ulrAssistence}/employee/schedule/assistance/$email'),
        headers: header,
      );
      final body = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final obj = ScheduleAndAssistence.fromJson(body);
        return obj;
      } else {
        throw Exception(body['message']);
      }
    } catch (e) {
      rethrow;
    }
  }
}
