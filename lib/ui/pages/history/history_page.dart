import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

import 'package:time_track/data/services/assistence_services.dart';
import 'package:time_track/styles/colors/colors.dart';
import 'package:time_track/ui/widgets/app_bar.dart';
import 'package:time_track/ui/pages/history/widgets/item_card.dart';
import 'package:time_track/data/models/record.dart';
import 'package:time_track/ui/widgets/progress_bar.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  static const String routeName = '/history';

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  void openDrawer() {
    Scaffold.of(context).openDrawer();
  }

  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(title: 'Historial'),
      body: FutureBuilder<List<Record>>(
        future: getAttendanceHistory(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final records = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Text(
                        //records[0].date.split(' ')[1],
                        getTitle(selectedDate!),
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      TextButton(
                          onPressed: () {
                            showMonthPicker(
                              context: context,
                              initialDate: DateTime.now(),
                            ).then((date) => {
                                  if (date != null)
                                    {
                                      setState(() {
                                        selectedDate = date;
                                      })
                                    }
                                });
                          },
                          child: const Text(
                            'Cambiar',
                            style: TextStyle(
                                fontSize: 14, color: MyColors.primary),
                          )),
                    ],
                  ),
                  Expanded(
                      child: ListView.builder(
                    itemCount: records.length,
                    itemBuilder: (context, index) {
                      final record = records[index];
                      return ItemCard(
                        item: record,
                      );
                    },
                  ))
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
                style: const TextStyle(
                  color: MyColors.red,
                  fontSize: 20,
                ),
              ),
            );
          } else {
            return const Center(
                child: MyProgressBar(color: MyColors.accent, size: 50));
          }
        },
      ),
    );
  }

  String getTitle(DateTime date) {
    final monthOfYear = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembew',
      'Diciembre'
    ];
    return monthOfYear[date.month - 1];
  }

  Future<List<Record>> getAttendanceHistory() async {
    try {
      final year = selectedDate!.year;
      final month = selectedDate!.month;
      final record = await AsistenceServices()
          .getAttendanceHistory(year: year, month: month);
      return record;
    } catch (error) {
      rethrow;
    }
  }
}
