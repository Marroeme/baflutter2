import 'dart:async';
import 'package:baflutter2/presentation/widgets/notifications_service.dart';
import 'package:flutter/material.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Timer? _timer;
  int _start = 5; // Standardmäßig auf 60 Sekunden gesetzt

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          timer.cancel();
          NotificationService().showNotification();
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
