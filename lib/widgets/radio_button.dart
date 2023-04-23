import 'package:dynamic_color_theme/dynamic_color_theme.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class RadioButton extends StatefulWidget {
  final String label;
  // final bool keyValue;
  final String prefsKey;
  final double width;
  final VoidCallback onChanged;
  const RadioButton({
    super.key,
    required this.label,
    required this.width,
    required this.prefsKey,
    required this.onChanged,
  });

  @override
  State<RadioButton> createState() => _RadioButtonState();
}

class _RadioButtonState extends State<RadioButton> {
  late bool prefsKeyValue;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    prefsKeyValue = prefs.getBool(widget.prefsKey)!;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white10, borderRadius: BorderRadius.circular(10)),
      width: widget.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: !prefsKeyValue ? Colors.white : Colors.white10,
                ),
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      prefsKeyValue = false;
                      prefs.setBool(widget.prefsKey, prefsKeyValue);
                    });
                    widget.onChanged();
                    // print(prefs.getBool(Constants.autoStartBreakKey));
                  },
                  icon: Icon(
                    Icons.close,
                    color: !prefsKeyValue
                        ? DynamicColorTheme.of(context).color
                        : Colors.white,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: prefsKeyValue ? Colors.white : Colors.white10,
                ),
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      prefsKeyValue = true;
                      prefs.setBool(widget.prefsKey, prefsKeyValue);
                    });
                    // print(prefs.getBool(Constants.autoStartBreakKey));
                    widget.onChanged();
                  },
                  icon: Icon(
                    Icons.check,
                    color: prefsKeyValue
                        ? DynamicColorTheme.of(context).color
                        : Colors.white,
                  ),
                ),
              )
            ],
          ),
          Text(
            widget.label,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ],
      ),
    );
  }
  void onChanged() {
    widget.onChanged();
  }
}
