import 'package:flutter/material.dart';

import 'package:pomodoro/utils/globals.dart';

class CustomIconButton extends StatelessWidget {
  final VoidCallback callback;
  final IconData iconData;
  final bool isDisabled;
  final double iconSize;
  const CustomIconButton({
    super.key,
    required this.callback,
    required this.iconData,
    required this.isDisabled,
    required this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: isDisabled ? null : callback,
      icon: Icon(iconData),
      color: text,
      disabledColor: Colors.grey,
      iconSize: iconSize,
    );
  }
}
