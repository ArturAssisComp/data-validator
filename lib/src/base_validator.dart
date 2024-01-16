import 'package:data_validator/data_validator.dart';

/// {@template BaseValidator}
/// This class is the base class for building validators. It should be inherited
/// in order to create custom validators.
/// {@endtemplate}
abstract base class BaseValidator<T> {
  /// {@template BaseValidator_target}
  /// This parameter represents the object to be validated. Its type must be
  /// defined in the concrete class that inherits from [BaseValidator].
  /// {@endtemplate}
  final T target;

  /// {@template BaseValidator_validationStatus}
  /// The current validation status being used to validate some data. It is
  /// important to note that this instance will be modified as the validation
  /// process happens.
  /// {@endtemplate}
  final ValidationStatus _validationStatus;

  final List<({ValidationMethod method, bool executed})> _validationPipeline =
      [];

  /// Returns the number of validation methods that still need to be executed.
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

  /// Executes the pipeline and clear the pipeline queue.
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
