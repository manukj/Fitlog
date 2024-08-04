import 'package:logger/logger.dart';

class AppLogger {
  final _logger = Logger();
  static final AppLogger _instance = AppLogger._internal();

  factory AppLogger() {
    return _instance;
  }

  AppLogger._internal();

  void log(String message) {
    _logger.i(message);
  }

  void error(String message) {
    _logger.e(message);
  }

  void warning(String message) {
    _logger.w(message);
  }

  void debug(String message) {
    _logger.d(message);
  }
}

final appLogger = AppLogger();
