import 'package:flutter/material.dart';
import 'package:pomodoro/main.dart';
import 'package:pomodoro/utils/pomodoro.dart';
import 'package:pomodoro/widgets/iconbutton.dart';

class SettingsDialog extends StatefulWidget {
  final Pomodoro pomodoro;
  const SettingsDialog({super.key, required this.pomodoro});

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  late Pomodoro pomodoro;
  late int value;
  @override
  void initState() {
    pomodoro = widget.pomodoro;
    value = pomodoro.period;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white12,
      child: Container(
        padding: const EdgeInsets.all(10),
        width: 300,
        height: 300,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded)),
            ),
            Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      pomodoro.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CustomIconButton(
                            callback: () {
                              setState(() => value--);
                            },
                            iconData: Icons.remove_rounded,
                            isDisabled: false,
                            iconSize: 25),
                        Text(
                          '$value',
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                        CustomIconButton(
                            callback: () {
                              setState(() => value++);
                            },
                            iconData: Icons.add_rounded,
                            isDisabled: false,
                            iconSize: 25),
                      ],
                    ),
                    ElevatedButton(
                        onPressed: () {
                          // var prevList = prefs.getStringList("pomodoros");
                          int index = pomodoros
                              .indexWhere((p) => p.name == pomodoro.name);
                          Pomodoro newPomdoro =
                              Pomodoro(name: pomodoro.name, period: value);
                          pomodoros[index] = newPomdoro;
                          prefs.setStringList("pomodoros",
                              pomodoros.map((p) => p.toJson()).toList());
                          Navigator.pop(context);
                        },
                        child: const Text("Save"))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
