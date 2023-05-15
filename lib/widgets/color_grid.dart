import 'package:dynamic_color_theme/dynamic_color_theme.dart';
import 'package:flutter/material.dart';
import 'package:resize/resize.dart';

import '../main.dart';
import '../utils/constants.dart';

class ColorGrid extends StatefulWidget {
  final double width;

  const ColorGrid({super.key, required this.width});

  @override
  State<ColorGrid> createState() => _ColorGridState();
}

class _ColorGridState extends State<ColorGrid> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white10,
      ),
      width: widget.width,
      child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: Constants.colors.length,
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount:
                  ResizeUtil().deviceType == DeviceType.Mobile ? 6 : 6,
              mainAxisSpacing: widget.width / 100,
              crossAxisSpacing: widget.width / 100),
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () async {
                await DynamicColorTheme.of(context).setColor(
                  color: Constants.colors[index],
                  shouldSave: true,
                );
                setState(() {});
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Constants.colors[index],
                ),
                child: Constants.colors
                            .indexOf(DynamicColorTheme.of(context).color) ==
                        index
                    ? Icon(
                        Icons.check,
                        size: isMobile ? 1.rem : 2.rem,
                      )
                    : const SizedBox.shrink(),
              ),
            );
          }),
    );
  }
}
