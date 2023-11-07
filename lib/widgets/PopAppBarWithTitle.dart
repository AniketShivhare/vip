import 'package:flutter/material.dart';

class PopAppBarWithTitle extends StatelessWidget {
  final String title;
  const PopAppBarWithTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.keyboard_arrow_left_outlined,
              color: Colors.black,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            title,
            style: const TextStyle(
                fontWeight: FontWeight.w500, fontSize: 14, color: Colors.black),
          ),
        ],
      ),
    );
  }
}