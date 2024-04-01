import 'package:flutter/material.dart';

class FeatureBox extends StatelessWidget {
  final Color color;
  final String headerText;
  final String descriptionText;
  const FeatureBox(
      {required this.color,
      required this.headerText,
      required this.descriptionText,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32)
          .copyWith(top: 10, bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: color,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0).copyWith(
          left: 15,
        ),
        child: Column(children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              headerText,
              style: const TextStyle(
                fontFamily: 'Cera Pro',
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Text(
              descriptionText,
              style: const TextStyle(fontFamily: 'Cera Pro', fontSize: 13),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
        ]),
      ),
    );
  }
}
