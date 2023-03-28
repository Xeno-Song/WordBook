import 'package:flutter/material.dart';

class TextInputField extends StatefulWidget {
  const TextInputField({super.key, required this.textEditingController, required this.fieldName});

  final String fieldName;
  final TextEditingController textEditingController;

  @override
  State<StatefulWidget> createState() {
    return _TextInputFieldState();
  }
}

class _TextInputFieldState extends State<TextInputField> {
  @override
  Widget build(BuildContext context) {
    String fieldName = widget.fieldName;

    return Container(
      padding: const EdgeInsets.all(20),
      child: TextField(
        decoration: InputDecoration(
          labelText: fieldName,
          fillColor: Colors.white,
          labelStyle: const TextStyle(
            color: Colors.white,
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: Colors.white,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: Colors.white,
            ),
          ),
          hoverColor: const Color.fromARGB(0xFF, 0x4C, 0x4B, 0x4F),
        ),
        style: const TextStyle(
          color: Colors.white,
        ),
        controller: widget.textEditingController,
      ),
    );
  }
}
