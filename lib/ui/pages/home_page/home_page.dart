import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:time_track/data/services/location_services.dart';
import 'package:time_track/styles/colors/colors.dart';
import 'package:time_track/ui/pages/home_page/widgets/info_panel.dart';
import 'package:time_track/ui/pages/home_page/widgets/map_container.dart';
import 'package:time_track/ui/widgets/app_bar.dart';
import 'package:time_track/ui/widgets/progress_bar.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  static const String routeName = '/';

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String location = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(title: 'TimeTrack'),
      body: Center(
        child: FutureBuilder<Map<String, dynamic>>(
          future: initialize(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  Expanded(
                    flex: 6,
                    child: MapContainer(
                      zoneCoordinates: snapshot.data!['zoneCoordinates'],
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: InfoPanel(
                      title: snapshot.data!['location'],
                      nameSchedule: snapshot.data!['scheduleAndAssistence']
                          ['nameSchedule'],
                      schedule: snapshot.data!['scheduleAndAssistence']
                          ['schedule'],
                      lastRecord: snapshot.data!['scheduleAndAssistence']
                          ['lastRecord'],
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return const MyProgressBar(color: MyColors.primary, size: 40);
            }
          },
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> initialize() async {
    try {
      final locationService = LocationServices();
      final position = await locationService.determinePosition();
      final placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      final locality = placemarks.first.locality;
      final street = placemarks.first.street;
      final zoneCoordinates = await getAssignZone();
      final scheduleAndAssistence = await getScheduleAndAssistence();
      return {
        'location': '$locality, $street',
        'position': position,
        'zoneCoordinates': zoneCoordinates,
        'scheduleAndAssistence': scheduleAndAssistence,
      };
    } catch (e) {
      throw Exception(
          'Error al inicializar la pagina, intente mas tarde, o contacte con el administrador');
    }
  }

  Future<List<List<double>>> getAssignZone() async {
    try {
      final coordinates = await LocationServices().getAssignZone();
      return coordinates;
    } catch (e) {
      throw Exception(
          'Error al obtener la zona asignada , intente mas tarde, o contacte con el administrador');
    }
  }

  Future<Map<String, String>> getScheduleAndAssistence() async {
    try {
      final schedule = await LocationServices().getScheduleAndAssistence();
      final nameSchedule = schedule.nameSchedule;
      final timeSchedule =
          "${schedule.currenteSchedule.startHour.substring(0, schedule.currenteSchedule.startHour.length - 3)} - ${schedule.currenteSchedule.endHour.substring(0, schedule.currenteSchedule.endHour.length - 3)}";
      final lastAssistence = schedule.lastRecord;
      String lastRecord = '';
      if (lastAssistence == null) {
        lastRecord = 'No hay marcaciones';
      } else {
        final today = DateTime.now();
        DateTime lastAssistenceDate = DateTime.parse(lastAssistence.date);
        if (today.day == lastAssistenceDate.day &&
            today.month == lastAssistenceDate.month &&
            today.year == lastAssistenceDate.year) {
          lastRecord = 'Ultima marcacion: ${lastAssistence.check}';
        } else {
          lastRecord =
              "${lastAssistence.date} [${lastAssistence.check.substring(0, lastAssistence.check.length - 3)}] - ${lastAssistence.recordType}";
        }
      }
      return {
        'nameSchedule': nameSchedule,
        'schedule': timeSchedule,
        'lastRecord': lastRecord,
      };
    } catch (e) {
      print(e);
      throw Exception(
          'Error al obtener el horario y asistencia, intente de nuevo, o contacte al administrador');
    }
  }
}
