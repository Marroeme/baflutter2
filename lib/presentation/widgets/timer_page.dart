import 'dart:async';
import 'package:baflutter2/presentation/widgets/notifications_service.dart';
import 'package:flutter/material.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  final NotificationService _notificationService = NotificationService();

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Timer? _timer;
  static const int initTimerZeit = 5;
  int _start = initTimerZeit;

  void startTimer() {
    _timer
        ?.cancel(); // Stellt sicher, dass der aktuelle Timer gestoppt wird, bevor ein neuer gestartet wird.

    setState(() {
      _start =
          initTimerZeit; // Oder ein anderer Wert, je nach deiner Anforderung.
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          timer.cancel();
          _notificationService.showNotification();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timer Notification'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("$_start Sekunden verbleibend"),
            ElevatedButton(
              onPressed: () {
                startTimer();
              },
              child: const Text('Start Timer'),
            ),
          ],
        ),
      ),
    );
  }
}
