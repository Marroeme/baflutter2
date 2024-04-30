import 'package:baflutter2/presentation/widgets/auftrag_pdf_page.dart';
import 'package:baflutter2/presentation/widgets/location_page.dart';
import 'package:baflutter2/presentation/widgets/notifications_service.dart';
import 'package:baflutter2/presentation/widgets/photo_page.dart';
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
        initialRoute: '/',
        routes: {
          '/': (context) => const LoginPage(),
          '/location': (context) => const LocationPage(),
          '/notifications': (context) => const TimerPage(),
          '/photos': (context) => const PhotoPage(),
          '/pdf': (context) => const AuftragPDFPage(),
        } // Setze LoginPage als Startseite
        );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  Widget _buildDrawerItem(
      context, IconData icon, String title, String routeName) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.pop(context); // Schließt den Drawer
        Navigator.pushNamed(context, routeName); // Verwendet benannte Routen
      },
    );
  }

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
            _buildDrawerItem(context, Icons.face, 'Biometrie', '/'),
            _buildDrawerItem(
                context, Icons.gps_fixed, 'Standortabfrage', '/location'),
            _buildDrawerItem(context, Icons.notifications, 'Benachrichtigungen',
                '/notifications'),
            _buildDrawerItem(context, Icons.photo_camera, 'Fotos', '/photos'),
            _buildDrawerItem(
                context, Icons.picture_as_pdf, 'PDF Generator', '/pdf'),
          ],
        ),
      ),
      body: const Center(
        child: Text(
          "Wähle eine Anforderung aus dem Drawer.",
          style: TextStyle(fontSize: 20.0),
        ),
      ),
    );
  }
}
