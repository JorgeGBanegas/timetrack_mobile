import 'dart:convert';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:time_track/api.dart';
import 'package:http/http.dart' as http;

import '../../utils/auth_messages.dart';

class AuthService {

  final _store = const FlutterSecureStorage();

  Future<void> saveToken(String token) async {
    await _store.write(key: 'token', value: token);
    await _store.write(key: 'token_created', value: DateTime.now().toString());

  }

  Future<void> deleteData() async {
    await _store.delete(key: 'token');
    await _store.delete(key: 'token_created');
  }

  Future<Map<String,String>> getToken() async {
    final token = await _store.read(key: 'token');
    final tokenCreated = await _store.read(key: 'token_created');
    return {
      'token': token ?? '',
      'token_created': tokenCreated ?? '',
    };
  }

  Future<Map<String, dynamic>> signInUser({
      required String email,
      required String password,
    }) async{

    try{
      final response = await http.post(
        Uri.parse('${Api.baseUrl}/auth/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
            'email': email,
            'password': password,
        }),
      );

      final jsonResult = jsonDecode(response.body);

      if(response.statusCode == 200){
        // verificar que exista una campo token en el body
        if(jsonResult.containsKey('access_token')){
          final token = jsonResult['access_token'];
          await saveToken(token);
          return {
            'status': AuthMessages.login,
            'session': '',
          };
        }else{
          return {
            'status': AuthMessages.newPasswordRequired,
            'session':  jsonResult['session'], 
          };
        }
      }else{
        return jsonResult['detail'];
      }

    }catch(e){
      safePrint(e);
      rethrow;
    }    
  }

  Future<String> resetPassword({required String email,
                                required String newPassword, 
                                required String session}) async{
    try{
      final response = await http.post(
        Uri.parse('${Api.baseUrl}/auth/new-password'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
            'email': email,
            'password': newPassword,
            'session': session,
        }),
      );

      final jsonResult = jsonDecode(response.body);
      
      if(response.statusCode == 200){
        final accessToken = jsonResult['access_token'];
        await saveToken(accessToken);
        return AuthMessages.login;
      }else{
        return jsonResult['detail']['message'];
      }

    }catch(e){
      safePrint(e);
      rethrow;
    }    
  }

  Future<void> logout({ required String accessToken}) async {
    try{
      final header = {
        'Authorization': 'Bearer $accessToken',
      };

      final response = await http.post(
        Uri.parse('${Api.baseUrl}/auth/signout'),
        headers: header,
      );

      if(response.statusCode == 200){
        safePrint('Sesión cerrada');
        await deleteData();
      }else{
        throw Exception('Error al cerrar sesión');
      }

    }catch(e){
      safePrint(e);
      rethrow;
    }
  } 
}