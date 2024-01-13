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
  final ValidationStatus validationStatus;

  /// {@macro BaseValidator}
  ///
  /// ## Parameters
  /// ### Named Parameters
  /// - final T `target`:
  /// {@macro BaseValidator_target}
  /// - final [ValidationStatus] `validationStatus`:
  /// {@macro BaseValidator_validationStatus}
  BaseValidator({required this.target, required this.validationStatus});

  /// Executes the pipeline and clear the pipeline queue.
  void validate() {}
}
