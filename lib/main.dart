import 'package:baflutter2/presentation/widgets/location_page.dart';
import 'package:baflutter2/presentation/widgets/notifications_service.dart';
import 'package:baflutter2/presentation/widgets/timer_page.dart';
import 'package:flutter/material.dart';
import 'presentation/widgets/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      home: LoginPage(), // Setze LoginPage als Startseite
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Willkommen"),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                height: 100,
                width: double.infinity,
                color: Colors.transparent,
                alignment: Alignment.bottomLeft,
                padding: const EdgeInsets.only(bottom: 8, left: 16),
                child: Text(
                  'Funktionen',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800],
                    fontSize: 28,
                  ),
                ),
              ),
              Builder(
                builder: (context) => ListTile(
                  leading: const Icon(Icons.face),
                  title: const Text('Biometrie'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      // Navigiert zurück zur Login-Seite
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                ),
              ),
              Builder(
                builder: (context) => ListTile(
                  leading: const Icon(Icons.gps_fixed),
                  title: const Text('Standortabfrage'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LocationPage()),
                    );
                  },
                ),
              ),
              Builder(
                builder: (context) => ListTile(
                  leading: const Icon(Icons.notifications),
                  title: const Text('Benachrichtigungen'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TimerPage()),
                    );
                  },
                ),
              ),
              Builder(
                builder: (context) => ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Fotoaufnahme'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Builder(
                builder: (context) => ListTile(
                  leading: const Icon(Icons.edit_square),
                  title: const Text('Photo Editor'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Builder(
                builder: (context) => ListTile(
                  leading: const Icon(Icons.save),
                  title: const Text('Lokale Speicherung'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Builder(
                builder: (context) => ListTile(
                  leading: const Icon(Icons.picture_as_pdf),
                  title: const Text('PDF Generator'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
        body: const Center(
          child: Text(
            "Wähle eine Anforderung aus dem Drawer.",
            style: TextStyle(fontSize: 20.0),
          ),
        ));
  }
}
