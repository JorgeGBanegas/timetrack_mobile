import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:time_track/data/services/location_services.dart';
import 'package:time_track/styles/colors/colors.dart';
import 'package:time_track/ui/pages/home_page/widgets/camera.dart';
import 'package:time_track/ui/widgets/button.dart';

class InfoPanel extends StatefulWidget {
  final String title;
  final String nameSchedule;
  final String schedule;
  final String lastRecord;
  const InfoPanel(
      {Key? key,
      required this.title,
      required this.nameSchedule,
      required this.schedule,
      required this.lastRecord})
      : super(key: key);

  @override
  State<InfoPanel> createState() => _InfoPanelState();
}

class _InfoPanelState extends State<InfoPanel> {
  String location = '';
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.only(left: 16, top: 16),
                      child: Icon(
                        Icons.location_pin,
                        size: 30,
                        color: MyColors.red,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16, top: 16),
                      child: Text(
                        widget.title,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(left: 32, right: 32),
                child: Divider(
                  thickness: 1,
                ),
              )
            ],
          ),
        ),
        Expanded(
          flex: 4,
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('${widget.nameSchedule} : ',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    Text(widget.schedule, style: const TextStyle(fontSize: 16)),
                  ],
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Ultimo registro : ',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(widget.lastRecord,
                        style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: MyButton(
                    onPressed: () {
                      safePrint('Entrada');
                      goToCamera('Entrada');
                    },
                    text: 'Entrada',
                    color: MyColors.primary,
                    textColor: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 16),
                    child: MyButton(
                      onPressed: () {
                        goToCamera('Salida');
                      },
                      text: 'Salida',
                      color: MyColors.red,
                      textColor: Colors.white,
                    )),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void goToCamera(String typeRecord) {
    Navigator.pushNamed(context, MyCamera.routeName, arguments: typeRecord);
  }

  Future<Position> getCurrentPosition() async {
    final locationService = LocationServices();
    final position = await locationService.determinePosition();
    return position;
  }

  void initialize() async {
    final position = await getCurrentPosition();
    final placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    final place = placemarks.first;
    setState(() {
      location = place.street.toString();
    });
  }
}
