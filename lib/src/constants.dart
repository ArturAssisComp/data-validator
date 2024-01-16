import 'package:data_validator/data_validator.dart';

/// Each validation method for a validation class that inherits from
/// BaseValidator must return [UnitValidationStatus] and does not receive any
/// argument as input.
typedef ValidationMethod = UnitValidationStatus Function();
