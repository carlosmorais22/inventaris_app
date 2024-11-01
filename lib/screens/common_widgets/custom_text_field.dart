import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final bool isSecret;
  final List<TextInputFormatter>? inputFormatters;
  final String? initialValue;
  final bool readOnly;

  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool autofocus;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final AutovalidateMode autovalidateMode;

  const CustomTextField(
      {Key? key,
        required this.label,
        this.isSecret = false,
        this.inputFormatters,
        this.initialValue,
        this.readOnly = false,
        this.autofocus = false,
        this.keyboardType = TextInputType.text,
        this.textInputAction = TextInputAction.next,
        this.controller,
        this.validator,
        this.autovalidateMode = AutovalidateMode.disabled})
      : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isObscure = false;

  @override
  void initState() {
    super.initState();

    isObscure = widget.isSecret;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 40,
        child: TextFormField(
        readOnly: widget.readOnly,
        initialValue: widget.initialValue,
        inputFormatters: widget.inputFormatters,
        obscureText: isObscure,
        style: Theme.of(context).textTheme.labelLarge,
        decoration: InputDecoration(
          errorStyle: TextStyle(fontSize: 0),
          labelStyle: Theme.of(context).textTheme.labelLarge,
          labelText: widget.label,
          isDense: true,
          border: OutlineInputBorder(
            // borderRadius: BorderRadius.circular(18),
          ),
        ),
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        autofocus: widget.autofocus,
        controller: widget.controller,
        validator: widget.validator,
        autovalidateMode: widget.autovalidateMode,
      ),
    );
  }
}
