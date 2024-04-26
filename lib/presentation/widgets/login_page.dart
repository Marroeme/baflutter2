import 'package:baflutter2/main.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:logger/logger.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final LocalAuthentication auth = LocalAuthentication();

  final Logger logger = Logger();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Login"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton.icon(
              icon: const Icon(Icons.face),
              label: const Text("Face ID"),
              onPressed: () =>
                  _authenticate(context, biometricMethod: BiometricType.face),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.fingerprint),
              label: const Text("Fingerprint"),
              onPressed: () => _authenticate(context,
                  biometricMethod: BiometricType.fingerprint),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _authenticate(BuildContext context,
      {required BiometricType biometricMethod}) async {
    bool authenticated = false;

    // Referenz auf den Navigator vor der asynchronen Operation sichern
    NavigatorState navigator = Navigator.of(context);

    try {
      authenticated = await auth.authenticate(
        localizedReason: 'Scan your fingerprint (or face) to authenticate',
        options: const AuthenticationOptions(
          biometricOnly: true,
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
    } catch (e) {
      logger.e('Error using local authentication: $e');
    }

    if (authenticated) {
      navigator.pushReplacement(
        MaterialPageRoute(builder: (context) => const MyHomePage()),
      );
    }
  }
}
