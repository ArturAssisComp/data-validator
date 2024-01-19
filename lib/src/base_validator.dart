import 'package:data_validator/data_validator.dart';

/// {@template BaseValidator}
/// A `BaseValidator` class serves as the foundation for creating custom 
/// validators.
/// It facilitates the registration and execution of validation methods for a 
/// specific type [T].
/// 
/// Example:
/// ```dart
/// final class StringValidator extends BaseValidator<String> {
///   SimpleValidator({required super.target, required super.validationStatus});
///   // Custom validation methods can be added here
/// }
/// ```
/// {@endtemplate}
abstract base class BaseValidator<T> {
  /// {@template BaseValidator_target}
  /// The target object to be validated.
  /// {@endtemplate}
  final T target;

  /// {@template BaseValidator_validationStatus}
  /// Tracks the current state of validation. This status is updated as 
  /// validation progresses.
  /// {@endtemplate}
  final ValidationStatus _validationStatus;

  final List<({ValidationMethod method, bool executed})> _validationPipeline =
      [];

  /// Returns the number of validation methods that still need to be executed.
  /// It may be used to check if there are any methods to be executed yet.
  int remainingValidationMethodsCount() => _validationPipeline.fold<int>(
        0,
        (previousValue, record) {
          final (executed: executed, method: _) = record;
          return previousValue + (executed ? 0 : 1);
        },
      );

  /// {@macro BaseValidator}
  ///
  /// ## Parameters
  /// ### Named Parameters
  /// - final T `target`:
  /// {@macro BaseValidator_target}
  /// - final [ValidationStatus] `validationStatus`:
  /// {@macro BaseValidator_validationStatus}
  BaseValidator({
    required this.target,
    required ValidationStatus validationStatus,
  }) : _validationStatus = validationStatus;

  /// While creating a new validator class, this method is used to registrate
  /// a new validation method. Validation methods are used as steps for the
  /// validation pipeline.
  ///
  /// ## Parameters
  /// ### Named Parameters
  /// - [ValidationMethod] `validationMethod`: the validation method to be
  /// registered.
  /// 
  /// ## Exception Handling
  /// This method throws a [ValidationFailure] exception if called after 
  /// finishing the validation process. The validation process is finished when 
  /// [ValidationStatus] is finished.
  /// - [ValidationFailure] with the following failureCode:
  // ignore: lines_longer_than_80_chars
  /// [ValidationFailureCode.addingNewValidationStepToFinishedValidationPipeline].
  void registerValidationMethod(
    ValidationMethod validationMethod,
  ) {
    if (_validationStatus.finished) {
      throw const ValidationFailure(
        failureCode: ValidationFailureCode
            .addingNewValidationStepToFinishedValidationPipeline,
      );
    }
    _validationPipeline.add((method: validationMethod, executed: false));
  }

  /// Executes the pipeline and clears it. This method must be called in order
  /// to actually execute the validation methods.
  /// 
  /// ## Exception Handling
  /// This method throws a [ValidationFailure] exception if called after 
  /// finishing the validation process. The validation process is finished when 
  /// [ValidationStatus] is finished.
  /// - [ValidationFailure] with the following failureCode:
  /// [ValidationFailureCode.executingValidationStepsOnFinishedPipeline].
  void validate() {
    if (_validationStatus.finished) {
      throw const ValidationFailure(
        failureCode:
            ValidationFailureCode.executingValidationStepsOnFinishedPipeline,
      );
    }
    for (var i = 0; i < _validationPipeline.length; i++) {
      final (method: method, executed: executed) = _validationPipeline[i];
      if (!executed) {
        final unitValidationStatus = method();
        _validationStatus.addResult(unitValidationStatus);
        _validationPipeline[i] = (executed: true, method: method);
      }
    }
  }
}
