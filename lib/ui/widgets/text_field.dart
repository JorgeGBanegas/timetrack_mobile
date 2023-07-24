import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  const MyTextField({
    Key? key,
    required this.hintText,
    required this.icon,
    required this.obscureText,
    required this.validator,
    required this.controller,
    required this.color,
  }) : super(key: key);

  final String hintText;
  final IconData icon;
  final bool obscureText;
  final String? Function(String?) validator;
  final TextEditingController controller;
  final Color color;
  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  final double _padding = 16.0;
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(_padding),
      child: TextFormField(
        validator: widget.validator,
        obscureText: widget.obscureText,
        controller: widget.controller,
        focusNode: _focusNode,
        style: TextStyle(color: widget.color),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(color: widget.color.withOpacity(0.5)),
          icon: IconTheme(
            data: IconThemeData(
              color: _isFocused ? Theme.of(context).primaryColor : widget.color.withOpacity(0.5),
            ), 
            child: Icon(widget.icon),
          ),
          
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: widget.color),
          ),
        ),
      ),
    );
  }
}