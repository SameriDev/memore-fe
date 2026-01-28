import 'dart:ui';
import 'package:flutter/material.dart';

class MessageInput extends StatelessWidget {
  final TextEditingController controller;
  final String placeholder;

  const MessageInput({
    super.key,
    required this.controller,
    this.placeholder = 'Add message...',
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2.9, sigmaY: 2.9),
        child: Container(
          width: 194,
          height: 28,
          decoration: BoxDecoration(
            color: const Color(0x59656565), // rgba(101,101,101,0.35)
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: TextField(
            controller: controller,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontFamily: 'Inika',
            ),
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontFamily: 'Inika',
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
