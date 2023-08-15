import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final String? hint;
  final InputBorder? inputBorder;
  final TextEditingController controller;
  const CustomInput({Key? key, this.onChanged, this.hint, this.inputBorder, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        onSubmitted: (v){},
        decoration: InputDecoration(hintText: hint!, border: inputBorder),
      ),
    );
  }
}
