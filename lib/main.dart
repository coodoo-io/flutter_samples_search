import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:samples/src/core/config/firebase_options.dart';
import 'package:samples/src/app.dart';
import 'package:samples/src/core/config/app_config.dart';
import 'package:samples/src/core/config/env.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized(); // makes sure plugins are initialized
    // Intl.systemLocale = await findSystemLocale(); // Tell the intl package the current system language

    // AppConfig (app configuration from environment variables)
    const env = String.fromEnvironment('ENV', defaultValue: 'dev');
    AppConfig(environment: env, logLevel: Env.logLevel);

    // Setup URL for GoRouter
    usePathUrlStrategy();

    // Global error catcher from the Flutter framework
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      debugPrint('${details.exceptionAsString()}, ${details.stack.toString()}');
    };

    runApp(
      const ProviderScope(
        child: App(),
      ),
    );
  }, (Object error, StackTrace stack) {
    debugPrint('${error.toString()}, ${stack.toString()}');
  });
}
