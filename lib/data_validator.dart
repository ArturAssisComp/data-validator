/// This lib implements a validation framework that makes it easier the process
/// of validating data. It helps the implementation of validation pipelines
/// with capability of tracing and receiving detailed information about the
/// failure.
///
/// ## Description
/// This validation framework is built upon the following main classes:
/// - `BaseValidator`, which must be inherited by the user to implement concrete
/// validators.
/// - `ValidationStatus`, which represents the general status of the validation
/// pipeline process.
/// - `UnitValidationStatus`, which represents the state of each validation
/// step. Multiple `UnitValidationStatus` compose a `ValidationStatus`.
///
/// Each validation process will be described by a `ValidationStatus`. While
/// unfinished, it may pass through multiple concrete validators. When finished,
/// its overall state represents the result of the validation pipeline.
///
/// Each validation process can be used as a `UnitValidationStatus` allowing the
/// making of nested validation processes.
library;

export 'src/base_validator.dart';
export 'src/constants.dart';
export 'src/unit_validation_status.dart';
export 'src/validation_failure.dart';
export 'src/validation_status.dart';
