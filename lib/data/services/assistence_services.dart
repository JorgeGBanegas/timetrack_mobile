import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:time_track/data/services/auth_services.dart';
import 'package:time_track/api.dart';
import 'package:http/http.dart' as http;

class AsistenceServices {
  Future<Map<String, dynamic>> registerAssistance(
      {required String base64Image,
      required String typeRecord,
      required double lat,
      required double lng}) async {
    try {
      Map<String, String> tokenData = await AuthService().getToken();
      final infoUser = await AuthService().getUserInfo();
      final photo = infoUser['image'];
      String token = tokenData['token']!;
      Map<String, String> header = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      safePrint(
          "🚀 ~ file: assistence_services.dart:26 ~ AsistenceServices ~ infoUser['email']: ${infoUser['email']}");

      Map<String, dynamic> req = {
        "employeeEmail": infoUser['email'],
        "referenceImage": photo,
        "compareImage": base64Image,
        "recordType": typeRecord, // "IN" or "OUT
        "location": [lat, lng],
      };
      safePrint(req);

      final response = await http.post(
        Uri.parse('${Api.ulrAssistence}/attendance-record/'),
        headers: header,
        body: jsonEncode(req),
      );
      dynamic body = jsonDecode(response.body);
      safePrint(
          "🚀 ~ file: assistence_services.dart:39 ~ AsistenceServices ~ body: $body");
      if (response.statusCode == 201) {
        return body;
      } else {
        throw Exception(body['message']);
      }
    } catch (error) {
      rethrow;
    }
  }
}
