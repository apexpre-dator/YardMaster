import 'package:flutter/material.dart';

class TextDisplay extends StatelessWidget {
  final String? hint;
  const TextDisplay({
    Key? key,
    this.hint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: TextField(
        decoration: InputDecoration(
          hintText: hint!,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
