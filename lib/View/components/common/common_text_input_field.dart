import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommonTextInputField extends StatefulWidget {
  const CommonTextInputField({
    super.key,
    this.controller,
    this.hint,
    this.padding = const EdgeInsets.fromLTRB(20, 10, 20, 10),
    this.errorMessage = null,
  });

  final TextEditingController? controller;
  final String? hint;
  final EdgeInsetsGeometry? padding;
  final String? errorMessage;

  @override
  State<StatefulWidget> createState() {
    return _CommonTextInputFieldState();
  }
}

class _CommonTextInputFieldState extends State<CommonTextInputField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.padding,
      child: TextField(
        controller: widget.controller,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
              width: 2,
            ),
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
              width: 2,
            ),
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          labelStyle: const TextStyle(
            color: Colors.white,
          ),
          errorStyle: const TextStyle(
            color: Colors.red,
          ),
          hintText: widget.hint,
          hintStyle: const TextStyle(
            color: Colors.white60,
          ),
          errorText: widget.errorMessage,
        ),
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
