import 'package:flutter/material.dart';
import 'package:news_app/constants.dart';

// ignore: must_be_immutable
class MyTextFormField extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  MyTextFormField({
    super.key,
    required TextEditingController controller,
    this.validatorCondition,
    this.maxLength,
    this.onTap,
    this.onChanged,
    required this.keyboardType,
    required this.obSecure,
    required this.labelText,
    required this.icon,
    required this.hintText,
  }) : _controller = controller;

  final TextEditingController _controller;
  String? Function(String?)? validatorCondition;
  int? maxLength;
  TextInputType keyboardType;
  bool obSecure;
  String labelText;
  IconData icon;
  String hintText;
  Future Function()? onTap;
  void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: TextFormField(
          onChanged: onChanged,
          onTap: onTap,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: validatorCondition,
          maxLength: maxLength,
          keyboardType: keyboardType,
          obscureText: obSecure,
          controller: _controller,
          cursorColor: Constants.appsMainColor,
          decoration: InputDecoration(
              labelStyle: const TextStyle(color: Constants.appsMainColor),
              labelText: labelText,
              prefixIcon: Icon(
                icon,
                color: Constants.appsMainColor,
              ),
              hintText: hintText,
              focusedErrorBorder: Constants().textfieldBorder,
              errorBorder: Constants().textfieldBorder,
              focusedBorder: Constants().textfieldBorder,
              enabledBorder: Constants().textfieldBorder),
        ),
      ),
    );
  }
}
