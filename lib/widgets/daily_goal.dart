import 'package:flutter/material.dart';

class DailyGoal extends StatelessWidget {
  final int dailyGoal;
  final int dailyComplete;
  const DailyGoal(
      {super.key, required this.dailyGoal, required this.dailyComplete});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2,
      child: Wrap(
        alignment: WrapAlignment.center,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ...List.generate(dailyGoal, (index) {
            return Container(
              margin: const EdgeInsets.all(5),
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: index < dailyComplete ? Colors.white : Colors.white12,
                borderRadius: BorderRadius.circular(10),
              ),
            );
          }),
        ],
      ),
    );
  }
}
