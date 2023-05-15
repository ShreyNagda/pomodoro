import 'package:flutter/material.dart';

import '../main.dart';
import 'number_set_dialog.dart';

class NumberSetter extends StatefulWidget {
  final String prefsKey;
  final String label;

  const NumberSetter({Key? key, required this.prefsKey, required this.label})
      : super(key: key);

  @override
  State<NumberSetter> createState() => _NumberSetterState();
}

class _NumberSetterState extends State<NumberSetter> {
  late int _value;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _value = prefs.getInt(widget.prefsKey) ?? 4;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(!isMobile ? 15 : 10),
          color: Colors.white12,
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            showDialog(
                context: context,
                builder: (_) {
                  return NumberSetDialog(
                    value: _value,
                    prefsKey: widget.prefsKey,
                  );
                }).then((value) {
              setState(() {});
            });
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${(prefs.getInt(widget.prefsKey))}',
                style: isMobile
                    ? Theme.of(context).textTheme.titleMedium
                    : isTablet
                        ? Theme.of(context).textTheme.bodyLarge
                        : Theme.of(context).textTheme.titleSmall,
              ),
              Text(
                widget.label,
                style: isMobile
                    ? Theme.of(context).textTheme.bodyMedium
                    : isTablet
                        ? Theme.of(context).textTheme.bodySmall
                        : Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }
}
