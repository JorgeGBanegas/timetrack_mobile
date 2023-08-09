import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:time_track/data/services/auth_services.dart';
import 'package:time_track/data/services/location_services.dart';
import 'package:time_track/styles/colors/colors.dart';
import 'package:time_track/ui/pages/history/history_page.dart';
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
        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: MyColors.primary,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'TimeTrack',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 10),
                    FutureBuilder<Map<String, String>>(
                      future: getInfoUser(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final userName = snapshot.data!['userName'];
                          final photoUrl = snapshot.data!['photo'];
                          return avatarWidget(userName!, photoUrl!);
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return const MyProgressBar(
                              color: Colors.white, size: 20);
                        }
                      },
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.history),
                title: const Text('Historial'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, HistoryPage.routeName);
                },
              ),
            ],
          ),
        ));
  }

  Future<Map<String, dynamic>> initialize() async {
    try {
      final locationService = LocationServices();
      final position = await locationService.determinePosition();
      final placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      final locality = placemarks.first.locality;
      final street = placemarks.first.street;
      List<List<double>>? zoneCoordinates = await getAssignZone();

      zoneCoordinates ??= [
        [position.latitude, position.longitude],
        [position.latitude, position.longitude]
      ];
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

  Future<List<List<double>>?> getAssignZone() async {
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
      final nameSchedule =
          schedule!.currenteSchedule == null ? 'Libre' : schedule.nameSchedule;
      final cuurrentSechedule = schedule.currenteSchedule;
      final timeSchedule =
          "${cuurrentSechedule == null ? '' : cuurrentSechedule.startHour.substring(0, cuurrentSechedule.startHour.length - 3)} - ${cuurrentSechedule == null ? '' : cuurrentSechedule.endHour.substring(0, cuurrentSechedule.endHour.length - 3)}";

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
      throw Exception(
          'Error al obtener el horario y asistencia, intente de nuevo, o contacte al administrador');
    }
  }

  Future<Map<String, String>> getInfoUser() async {
    try {
      final user = await AuthService().getUserInfo();
      return {
        'userName': user['first_name'] + ' ' + user['last_name'],
        'photo': user['image'],
      };
    } catch (e) {
      throw Exception('Error al obtener la informacion del usuario');
    }
  }

  Widget avatarWidget(String userName, String photoUrl) {
    return Row(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(photoUrl),
        ),
        const SizedBox(width: 10),
        Text(userName, style: const TextStyle(color: Colors.white)),
      ],
    );
  }
}
