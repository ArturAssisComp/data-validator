import 'package:data_validator/src/unit_validation_status.dart';

/// Each validation method for a validation class that inherits from
/// BaseValidator must return [UnitValidationStatus] and does not receive any
/// argument as input.
typedef ValidationMethod = UnitValidationStatus Function();
