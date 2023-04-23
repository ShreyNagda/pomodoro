import 'package:flutter/material.dart';
import 'package:resize/resize.dart';

class Button extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  const Button({super.key, required this.onTap, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: ResizeUtil().deviceType == DeviceType.Mobile ? 100.w : 10.mv,
      color: Colors.white,
    );
  }
}
