import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:time_track/styles/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TimeTrack',
      theme: ThemeData(
        primarySwatch: MyColors.themePrimaryColor,
      ),
      home: const MyHomePage(title: 'TimeTrack'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
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
