// Copyright (c) 2026 Qore. All rights reserved.
import 'package:flutter/material.dart';

/// 鎏金主按钮（对应 Python QSS 的 QPushButton#primary）。
class GoldButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  const GoldButton({super.key, required this.text, this.onPressed, this.icon});

  @override
  Widget build(BuildContext context) {
    final child = icon == null
        ? Text(
            text,
            style: const TextStyle(
                color: Color(0xFF1A1208),
                fontSize: 15,
                fontWeight: FontWeight.bold),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: const Color(0xFF1A1208), size: 18),
              const SizedBox(width: 6),
              Text(text,
                  style: const TextStyle(
                      color: Color(0xFF1A1208),
                      fontSize: 15,
                      fontWeight: FontWeight.bold)),
            ],
          );
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF0D488), Color(0xFFD4A857)],
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE8C87A)),
      ),
      child: MaterialButton(
        onPressed: onPressed,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: child,
      ),
    );
  }
}
