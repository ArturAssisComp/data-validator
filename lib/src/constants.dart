import 'package:data_validator/src/unit_validation_status.dart';

/// This definition describes the function signature for any kind of validation
/// method that may be implemented into validators. They are basically functions
/// without arguments that return a [UnitValidationStatus] instance.
typedef ValidationMethod = UnitValidationStatus Function();
