import 'package:logging/logging.dart';
import 'package:logging_appenders/logging_appenders.dart';

Future<void> setupLogger({required Level level}) async {
  Logger.root.level = level;
  PrintAppender(formatter: const ColorFormatter()).attachToLogger(Logger.root);
  // if (kDebugMode) {
  //   // Development Logging
  //   PrintAppender(formatter: const CustomLogFormatter(colorsEnabled: true)).attachToLogger(Logger.root);
  // } else {
  //   if (!kIsWeb) {
  //     // Release Logging
  //     RotatingFileAppender(
  //       formatter: const CustomLogFormatter(colorsEnabled: false),
  //       baseFilePath: '/counter_workshop_logs',
  //     ).attachToLogger(Logger.root);
  //   }
  // }
}
