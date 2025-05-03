import 'package:logger/logger.dart';

final logger = Logger();

void infoLog(String message) {
  logger.i(message);
}

void errorLog(String message) {
  logger.e(message);
}
