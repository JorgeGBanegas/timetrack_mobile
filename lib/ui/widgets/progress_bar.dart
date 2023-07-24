import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MyProgressBar extends StatefulWidget {
  final Color color;
  final double size; 
  const MyProgressBar({Key? key, required this.color, required this.size}) : super(key: key);

  @override
  State<MyProgressBar> createState() => _MyProgressBarState();
}

class _MyProgressBarState extends State<MyProgressBar> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitFadingFour(
        color: widget.color,
        size: widget.size,
      ),
    );
  }
}