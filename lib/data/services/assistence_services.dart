import 'dart:convert';

import 'package:time_track/data/services/auth_services.dart';
import 'package:time_track/api.dart';
import 'package:http/http.dart' as http;
import 'package:time_track/data/models/record.dart';

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

      Map<String, dynamic> req = {
        "employeeEmail": infoUser['email'],
        "referenceImage": photo,
        "compareImage": base64Image,
        "recordType": typeRecord, // "IN" or "OUT
        "location": [lat, lng],
      };

      final response = await http.post(
        Uri.parse('${Api.ulrAssistence}/attendance-record/'),
        headers: header,
        body: jsonEncode(req),
      );
      dynamic body = jsonDecode(response.body);

      if (response.statusCode == 201) {
        return body;
      } else {
        throw Exception(body['message']);
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<List<Record>> getAttendanceHistory(
      {required int year, required int month}) async {
    try {
      final infoUser = await AuthService().getUserInfo();
      final email = infoUser['email'];
      final token = await AuthService().getToken();

      Map<String, String> header = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await http.get(
        Uri.parse(
            '${Api.ulrAssistence}/attendance-record/history?email=$email&year=$year&month=$month'),
        headers: header,
      );

      dynamic body = jsonDecode(response.body);
      if (response.statusCode == 200) {
        List<Record> records = [];
        for (final item in body) {
          final date = DateTime.parse(item['date']).toIso8601String();
          final checkIn = item['checkIn']['check'];
          final checkOut =
              item['checkOut'] == null ? ' - ' : item['checkOut']['check'];
          records.add(Record.fromJson(
              {'date': date, 'checkIn': checkIn, 'checkOut': checkOut}));
        }

        return records;
      } else {
        throw Exception(body['message']);
      }
    } catch (error) {
      rethrow;
    }
  }
}
