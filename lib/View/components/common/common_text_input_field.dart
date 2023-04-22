import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommonTextInputField extends StatefulWidget {
  const CommonTextInputField({
    super.key,
    this.controller,
    this.hint,
    this.padding = const EdgeInsets.fromLTRB(20, 10, 20, 10),
    this.errorMessage,
    this.foregroundColor = Colors.white,
    this.onChanged = null,
  });

  final TextEditingController? controller;
  final String? hint;
  final EdgeInsetsGeometry? padding;
  final String? errorMessage;
  final Color foregroundColor;
  final Function(String)? onChanged;

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
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: widget.foregroundColor,
              width: 2,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: widget.foregroundColor,
              width: 2,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
          labelStyle: TextStyle(
            color: widget.foregroundColor,
          ),
          labelText: widget.hint,
          errorStyle: const TextStyle(
            color: Colors.red,
          ),
          hintText: widget.hint,
          hintStyle: TextStyle(
            color: Color.fromRGBO(
              widget.foregroundColor.red,
              widget.foregroundColor.green,
              widget.foregroundColor.blue,
              widget.foregroundColor.opacity * 0.6,
            ),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red,
              width: 2,
            ),
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red,
              width: 2,
            ),
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          errorText: widget.errorMessage,
        ),
        style: TextStyle(
          color: widget.foregroundColor,
        ),
        onChanged: (value) => widget.onChanged?.call(value),
      ),
    );
  }
}
