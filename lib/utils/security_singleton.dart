import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Required for RootIsolateToken
import 'dart:isolate';
import 'dart:async';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';

void securityCheck(List<dynamic> args) async {
  SendPort sendPort = args[0];
  RootIsolateToken rootIsolateToken = args[1];

  // Initialize BackgroundIsolateBinaryMessenger with the root isolate token
  BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);

  // Periodic check every 10 seconds
  Timer.periodic(const Duration(seconds: 10), (Timer timer) async {
    bool isJailBroken = await FlutterJailbreakDetection.jailbroken;
    bool isInDeveloperMode = await FlutterJailbreakDetection.developerMode;

    // If a security issue is detected, notify the main isolate
    if (isJailBroken || isInDeveloperMode) {
      sendPort.send(true);
    }
  });
}

class AppSecurityCheck {
  static Isolate? _isolate;
  static final ReceivePort _receivePort = ReceivePort();

  static Future<void> startSecurityCheck(BuildContext context) async {
    // Get the root isolate token
    final RootIsolateToken rootIsolateToken = RootIsolateToken.instance!;

    // Initialize the isolate and pass both the sendPort and the root isolate token
    _isolate = await Isolate.spawn(securityCheck, [_receivePort.sendPort, rootIsolateToken]);

    // Listen for messages from the isolate
    _receivePort.listen((message) {
      if (message == true) {
        _showSecurityDialog(context);
      }
    });
  }

  static void _showSecurityDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Security Alert"),
          content: const Text("Your device is either jailbroken or in developer mode. Please disable developer mode or quit the app."),
          actions: [
            TextButton(
              onPressed: () {
                _openDeveloperSettings();
              },
              child: const Text("Disable Developer Mode"),
            ),
            TextButton(
              onPressed: () {
                _quitApp();
              },
              child: const Text("Quit App"),
            ),
          ],
        );
      },
    );
  }

  static void _openDeveloperSettings() {
    // Code to open developer options settings
  }

  static void _quitApp() {
    SystemNavigator.pop();
  }

  static void stopSecurityCheck() {
    if (_isolate != null) {
      _isolate!.kill(priority: Isolate.immediate);
      _isolate = null;
    }
  }
}
