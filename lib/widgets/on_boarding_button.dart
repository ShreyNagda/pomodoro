import 'package:flutter/material.dart';

class OnBoardingButton extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;
  const OnBoardingButton({super.key, required this.onTap, required this.child});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(5),
      onTap: onTap,
      child: AnimatedContainer(
        width: 100,
        height: 40,
        duration: const Duration(milliseconds: 500),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: Center(child: child),
      ),
    );
  }
}
