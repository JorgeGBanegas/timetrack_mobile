import 'dart:convert';
import 'dart:io';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:face_camera/face_camera.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:time_track/data/services/assistence_services.dart';
import 'package:time_track/data/services/location_services.dart';
import 'package:time_track/styles/colors/colors.dart';
import 'package:time_track/ui/widgets/app_bar.dart';
import 'package:time_track/ui/widgets/progress_bar.dart';
import 'package:time_track/utils/app_utils.dart';

import '../../../widgets/button.dart';

class MyCamera extends StatefulWidget {
  const MyCamera({Key? key}) : super(key: key);
  static const routeName = '/camera';
  @override
  State<MyCamera> createState() => _MyCameraState();
}

class _MyCameraState extends State<MyCamera> {
  File? _capturedImage;
  bool _isLoading = false;
  bool _isRegistered = false;
  bool _showConfirmIcon = false;
  String messageResult = '';
  @override
  Widget build(BuildContext context) {
    safePrint('_isLoading: $_isLoading');
    String typeRecord = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
        appBar: const MyAppBar(title: 'TimeTrack'),
        body: Builder(builder: (context) {
          if (_capturedImage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Opacity(
                        opacity: _isLoading
                            ? 0.3
                            : 1.0, // Cambiar la opacidad según el estado de isLoading
                        child: Image.file(
                          _capturedImage!,
                          width: double.maxFinite,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      if (_isLoading) showProgress(),
                      if (_showConfirmIcon) _registerMessage(),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.only(
                            top: 8, bottom: 8, right: 4, left: 8),
                        child: MyButton(
                          text: 'Enviar',
                          color: MyColors.primary,
                          onPressed: () {
                            register(_capturedImage, typeRecord);
                          },
                          textColor: MyColors.white,
                        ),
                      )),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 8, bottom: 8, right: 8, left: 4),
                          child: MyButton(
                            text: 'Repetir',
                            color: MyColors.red,
                            onPressed: () {
                              safePrint('Repetir');
                              setState(() {
                                _capturedImage = null;
                                _showConfirmIcon = false;
                              });
                            },
                            textColor: MyColors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            );
          }
          return SmartFaceCamera(
              autoCapture: true,
              defaultCameraLens: CameraLens.front,
              onCapture: (File? image) {
                setState(() => _capturedImage = image);
              },
              onFaceDetected: (Face? face) {
                //Do something
              },
              messageBuilder: (context, face) {
                if (face == null) {
                  return _message('Pon tu cara en el cuadro');
                }
                if (!face.wellPositioned) {
                  return _message('Pon tu cara en el cuadro');
                }
                return const SizedBox.shrink();
              });
        }));
  }

  Widget showProgress() {
    return const MyProgressBar(
      color: MyColors.primary,
      size: 100,
    );
  }

  void toHome() {
    AppUtils.toHome(context);
  }

  Future<Position> getCurrentPosition() async {
    final locationService = LocationServices();
    final position = await locationService.determinePosition();
    return position;
  }

  void register(capturedImage, typeRecord) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String base64Image = base64Encode(capturedImage.readAsBytesSync());
      Position position = await getCurrentPosition();
      double latitude = position.latitude;
      double longitude = position.longitude;

      await AsistenceServices().registerAssistance(
          base64Image: base64Image,
          lat: latitude,
          lng: longitude,
          typeRecord: typeRecord);
      messageResult = 'Registro exitoso';
      _isRegistered = true;
      toHome();
    } catch (e) {
      _isRegistered = false;
      safePrint(
          "🚀 ~ file: camera.dart:156 ~ _MyCameraState ~ voidregister ~ e: $e");
      messageResult = e.toString().split(':')[1];
    } finally {
      setState(() {
        _isLoading = false;
        _showConfirmIcon = true;
      });
    }
  }

  Widget _registerMessage() {
    String message = messageResult;
    IconData icon =
        _isRegistered ? Icons.check_circle_outline_sharp : Icons.error;
    Color color = _isRegistered ? MyColors.primary : MyColors.red;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: color,
          size: 100,
        ),
        const SizedBox(height: 16),
        Text(
          message,
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _message(String msg) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 55, vertical: 15),
        child: Text(msg,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 20,
                height: 2,
                fontWeight: FontWeight.w700,
                color: MyColors.red)),
      );
}
