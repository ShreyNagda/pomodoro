import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:pomodoro/model/timer_model.dart';
import 'package:timer_controller/timer_controller.dart';

import '../pages/home_page.dart';

class NotificationService {
  static bool isInitialised = false;
  AwesomeNotifications notifications = AwesomeNotifications();
  Future<void> initialize() async {
    await notifications.initialize(
      null,
      [
        NotificationChannel(
            channelKey: 'pomodoro',
            channelName: 'Pomodoro',
            channelDescription:
                "This is the notification channel for pomodoro timer",
            importance: NotificationImportance.Low,
            playSound: false,
            onlyAlertOnce: true,
            enableVibration: false
            // enableLights: false,
            ),
      ],
      // debug: true,
    );
    // notifications.shouldShowRationaleToRequest();
    notifications.setListeners(
      onActionReceivedMethod: HomePage.onActionReceivedMethod,
    );
  }

  void createNotification(
    TimerModel timerModel,
    TimerController timerController,
  ) {
    String status = 'Start new session';

    notifications.createNotification(
      content: NotificationContent(
        criticalAlert: true,
        locked: true,
        id: 0,
        channelKey: 'pomodoro',
        title: '${timerModel.name} - $status',
        body: formatString(timerController.value.remaining),
        // notificationLayout: NotificationLayout.ProgressBar,
        color: Colors.primaries.first.shade300,
        autoDismissible: true,
      ),
      actionButtons: [
        NotificationActionButton(key: 'start', label: 'Start',)
      ]
    );
  }

  Future<bool> deleteNotification(int id) async {
    await notifications.dismiss(id);
    return true;
  }

  String formatString(int remaining) {
    return '${(remaining / 60).floor().toString().padLeft(2, "0")} : ${(remaining % 60).toString().padLeft(2, "0")}';
  }

  Future<void> deleteAllFromChannel() async {
    await notifications.cancelNotificationsByChannelKey('pomodoro');
  }
}
