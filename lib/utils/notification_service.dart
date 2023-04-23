import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:pomodoro/model/timer_model.dart';
import 'package:timer_controller/timer_controller.dart';

import '../pages/home_page.dart';

class NotificationService {
  // static bool isInitialised = false;
  // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  // Future<void> initialize() async {
  //   await flutterLocalNotificationsPlugin.initialize(const InitializationSettings(android: AndroidInitializationSettings('@mipmap/ic_launcher')));
  //   await flutterLocalNotificationsPlugin
  //       .resolvePlatformSpecificImplementation<
  //           AndroidFlutterLocalNotificationsPlugin>()!
  //       .requestPermission();
  //   isInitialised = true;
  // }
  // createNotification(String timername, int maxvalue, int value){
  //   var androidPlatformChannelSpecifics = AndroidNotificationDetails(
  //     'pomodoro_timer',
  //     'Pomodoro Timer',
  //     channelDescription: 'Pomodoro Timer Channel',
  //     importance: Importance.high,
  //     priority: Priority.high,
  //     onlyAlertOnce: true,
  //     autoCancel: true,
  //     // ongoing: true,
  //     showProgress: true,
  //     playSound: false,
  //     enableVibration: false,
  //     progress: value,
  //     maxProgress: maxvalue,
  //     channelShowBadge: false,
  //     color: Colors.primaries.first.shade400,
  //   );
  //   var platformChannelSpecifics = NotificationDetails(
  //     android: androidPlatformChannelSpecifics,
  //   );
  //   flutterLocalNotificationsPlugin.show(
  //     0,
  //     "$timername - ${(value / 60).floor().toString().padLeft(2, '0')} : ${(value % 60).toString().padLeft(2, "0")}",
  //     "",
  //     // "${(value / 60).floor().toString().padLeft(2, '0')} : ${(value % 60).toString().padLeft(2, "0")}",
  //     platformChannelSpecifics,
  //     payload: 'item x',
  //   );
  // }
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
          enableVibration: false,
          // enableLights: false,
        ),
      ],
    );
    notifications.setListeners(
      onActionReceivedMethod: HomePage.onActionReceivedMethod,
    );
  }

  void createNotification(
    TimerModel timerModel,
    TimerController timerController,
  ) {
    String status = (timerController.value.status == TimerStatus.initial ||
            timerController.value.status == TimerStatus.initial)
        ? 'ready for new session'
        : timerController.value.status.name;

    notifications.createNotification(
        content: NotificationContent(
          criticalAlert: true,
          locked: true,
          id: 0,
          channelKey: 'pomodoro',
          title: '${timerModel.name} - $status',
          body: formatString(timerController.value.remaining),
          progress:
              ((timerController.value.remaining / (timerModel.minutes * 60)) *
                      100)
                  .round(),
          notificationLayout: NotificationLayout.ProgressBar,
          color: Colors.primaries.first.shade300,
          autoDismissible: false,
        ),
        actionButtons: timerController.value.status == TimerStatus.initial
            ? [
                NotificationActionButton(
                  key: 'start',
                  label: 'Start',
                  showInCompactView: false,
                  autoDismissible: false,
                  actionType: ActionType.SilentAction,
                ),
                NotificationActionButton(
                  key: 'close',
                  label: 'close',
                  showInCompactView: false,
                  autoDismissible: false,
                  actionType: ActionType.SilentAction,
                ),
              ]
            : timerController.value.status == TimerStatus.running
                ? [
                    NotificationActionButton(
                      key: 'pause',
                      label: 'Pause',
                      showInCompactView: false,
                      autoDismissible: false,
                      actionType: ActionType.SilentAction,
                    ),
                  ]
                : [
                    NotificationActionButton(
                      key: 'resume',
                      label: 'Resume',
                      showInCompactView: true,
                      autoDismissible: false,
                      actionType: ActionType.SilentAction,
                    ),
                    NotificationActionButton(
                      key: 'reset',
                      label: 'Reset',
                      showInCompactView: true,
                      autoDismissible: false,
                      actionType: ActionType.SilentAction,
                    ),
                    NotificationActionButton(
                      key: 'close',
                      label: 'Close',
                      showInCompactView: true,
                      autoDismissible: false,
                      actionType: ActionType.SilentAction,
                    ),
                  ]);
  }

  Future<void> deleteNotification(int id) async {
    await notifications.cancel(id);
  }

  String formatString(int remaining) {
    return '${(remaining / 60).floor().toString().padLeft(2, "0")} : ${(remaining % 60).toString().padLeft(2, "0")}';
  }
}
