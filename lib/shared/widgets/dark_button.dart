// Copyright (c) 2026 Qore. All rights reserved.
import 'package:flutter/material.dart';

/// 深色次要按钮。
class DarkButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  const DarkButton({super.key, required this.text, this.onPressed});

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF3A2F4A), Color(0xFF241C30)],
          ),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color.fromRGBO(212, 168, 87, 0.43)),
        ),
        child: MaterialButton(
          onPressed: onPressed,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Text(
            text,
            style: const TextStyle(
                color: Color(0xFFF0E6CF),
                fontSize: 13,
                fontWeight: FontWeight.bold),
          ),
        ),
      );
}
