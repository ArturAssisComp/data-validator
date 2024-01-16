import 'dart:developer';

import 'package:data_validator/data_validator.dart';

void main() {
  final overallStatus = ValidationStatus(validationName: 'this status')
    ..addResult(
      const UnitValidationStatus(
        nodeName: 'any',
        status: UnitValidationStatusCode.notDefined,
      ),
    );
  log(overallStatus.status.toString());
}
