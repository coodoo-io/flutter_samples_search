// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

import 'package:samples/src/core/config/environment.dart';
import 'package:samples/src/core/logging/logger.dart';

class AppConfig {
  final log = Logger('AppConfig');
  final lineLength = 62;
  late final Environment environment;
  late final Level logLevel;
  late final MediaDeviceInfo deviceInfo;

  AppConfig({
    required String environment,
    required String logLevel,
  }) {
    this.environment = Environment.values.byName(environment.toLowerCase());
    this.logLevel = Level.LEVELS.firstWhere(
      (l) => l.name == logLevel.toUpperCase(),
      orElse: () => Level.OFF,
    );

    // Setup Logger
    setupLogger(level: this.logLevel);

    log.info(
      '+--------------------------------------------------------------+',
    );
    log.info(
      '| Environment: ${this.environment.name.padRight(lineLength - 17 + this.environment.name.length, " ")}|',
    );
    log.info(
      '+--------------------------------------------------------------+',
    );
  }

  bool isProduction() => environment == Environment.prod;
  bool isDevelopment() => environment == Environment.dev;
  bool isStaging() => environment == Environment.stage;

  static bool get isWeb => kIsWeb;
  static bool get isDebugMode => kDebugMode;
  static bool get isReleaseMode => kReleaseMode;
}
