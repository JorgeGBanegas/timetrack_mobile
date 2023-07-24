import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:time_track/ui/widgets/app_bar.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});


  static const String routeName = '/';

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(title: 'TimeTrack'),
      body: Center(
        child: Column(
          children: <Widget>[
            // cargar imagen svg
            SvgPicture.asset(
              'assets/logo.svg',
              width: 200,
              height: 200,
              semanticsLabel: 'Logo',
            ),
            const Text(
              'Bienvendio a TimeTrack',
            ),
          ],
        ),
      ),
    );
  }
}
