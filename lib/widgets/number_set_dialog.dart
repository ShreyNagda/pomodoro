import 'package:flutter/material.dart';

import '../main.dart';

class NumberSetDialog extends StatefulWidget {
  final int value;
  final String prefsKey;

  const NumberSetDialog({Key? key, required this.value, required this.prefsKey})
      : super(key: key);

  @override
  State<NumberSetDialog> createState() => _NumberSetDialogState();
}

class _NumberSetDialogState extends State<NumberSetDialog> {
  late int _value;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            // width: widget.width,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        _value = _value - 1;
                        // _value = newValue.clamp(0, 60);
                      });
                    },
                    icon: const Icon(Icons.remove)),
                Text(
                  '$_value',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _value = _value + 1;
                    });
                  },
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ),
          // SizedBox(height: widget.width / 50,),
          IconButton(
            onPressed: () {
              prefs.setInt(widget.prefsKey, _value);
              Navigator.pop(context);
            },
            icon: const Icon(Icons.check),
          )
        ],
      ),
    );
  }
}
