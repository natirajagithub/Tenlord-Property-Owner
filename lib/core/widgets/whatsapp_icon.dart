import 'package:flutter/material.dart';

class WhatsAppIcon extends StatelessWidget {
  final double size;

  const WhatsAppIcon({
    super.key,
    this.size = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/whatsapp.png',
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (ctx, err, stack) => Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: Color(0xFF25D366),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(
            Icons.chat_bubble_rounded,
            size: size * 0.6,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
