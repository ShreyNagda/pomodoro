import 'package:dynamic_color_theme/dynamic_color_theme.dart';
import 'package:flutter/material.dart';
import 'package:resize/resize.dart';

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
        borderRadius: BorderRadius.circular(
          10,
        ),
        color: Colors.white10,
      ),
      width: widget.width,
      child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: Colors.primaries.length,
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
                  color: Colors.primaries[index].shade300,
                  shouldSave: true,
                );
                setState(() {});
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.primaries[index].shade300,
                ),
                child: Colors.primaries
                            .map((e) => e.shade300)
                            .toList()
                            .indexOf(DynamicColorTheme.of(context).color) ==
                        index
                    ? Icon(Icons.check,size: 1.rem,)
                    : const SizedBox.shrink(),
              ),
            );
          }),
    );
  }
}
