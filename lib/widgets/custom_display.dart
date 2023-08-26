import 'package:flutter/material.dart';

class CustomDisplay extends StatelessWidget {
  final String title;
  const CustomDisplay({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // decoration: BoxDecoration(
      //     border: Border.all(color: Colors.black45),
      //     borderRadius: const BorderRadius.all(Radius.circular(5))),
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 3,
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
        ),
      ),
    );
  }
}
