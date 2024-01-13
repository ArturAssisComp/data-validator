import 'dart:developer';

import 'package:data_validator/data_validator.dart';

void main() {
  final overallStatus = ValidationStatus(validationName: 'this status');
  log(overallStatus.status.toString());
}
