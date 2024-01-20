/// Enumeration of failure types for the [ValidationFailure] class.
///
/// This enum provides specific codes and messages associated with different
/// types of failures that can occur during the validation process. Each
/// failure code includes a detailed message that describes the nature of the
/// failure, aiding in diagnosing issues in the validation pipeline.
enum ValidationFailureCode {
  /// Failure code for attempting to add a new validation state to a validation
  /// pipeline that has already concluded its process.
  ///
  /// This failure is triggered when there is an attempt to modify the state of
  /// a validation pipeline that is already marked as finished, indicating a
  /// potential flaw in the validation logic or flow control.
  addingStateToFinishedValidationPipeline(
    message: 'Failed to add a new result: the validation pipeline has already '
        'finished.',
  ),

  /// Failure code for attempting to add a new validation step to a validation
  /// pipeline that has already concluded its process.
  ///
  /// This failure occurs when a new validation step is attempted to be added to
  /// a validation pipeline that is already marked as completed. This scenario
  /// typically indicates a logic error where the validation process is being
  /// modified post completion, which could lead to inconsistent or invalid
  /// validation states.
  addingNewValidationStepToFinishedValidationPipeline(
    message: 'Failed to add a new validation step: the validation pipeline '
        'is already complete.',
  ),

  /// Failure code for attempting to add an undefined state to the validation
  /// pipeline.
  ///
  /// This occurs when a validation status without a definitive state (such as
  /// 'notDefined', unfinished warning or unfinished success) is being added to
  /// a `ValidationStatus`. For proper functioning, the validation status should
  /// have a well-defined final state like 'failed', 'success', 'warning', or a
  /// definitive state for unfinished validations (only 'failed').
  addingNotDefinedStateToValidationPipeline(
    message: 'Failed to add a new result: the validation status is undefined. '
        'A well-defined final state is required. If the state to be added is '
        'not finished, only "failed" is accepted. If it is finished, '
        '"failed", "success", or "warning" are accepted.',
  ),

  /// Failure code for attempting to execute validation steps on a validation
  /// pipeline that has already concluded its process.
  ///
  /// This error is raised when there is an attempt to execute additional
  /// validation steps in a pipeline that has already been marked as finished.
  /// This typically indicates an error in the process flow where validation
  /// steps are being applied after the pipeline should have ceased operations,
  /// potentially leading to incorrect or misleading validation results.
  executingValidationStepsOnFinishedPipeline(
    message: 'Execution attempt on a finished validation pipeline: no further '
        'validation steps can be processed.',
  ),

  /// Enumeration for code 'unknown'
  unknown(
    message: 'Unknown excepction occurred.',
  );

  /// More detailed message describing the failure.
  final String message;
  const ValidationFailureCode({required this.message});
}

/// {@template ValidationFailure}
/// Failure thrown during the validation process.
/// {@endtemplate}
class ValidationFailure implements Exception {
  /// The related [ValidationFailureCode] element that gives
  /// details about the validation failure.
  final ValidationFailureCode failureCode;

  /// {@macro ValidationFailure}
  const ValidationFailure({this.failureCode = ValidationFailureCode.unknown});

  @override
  String toString() => 'ValidationFailure: ${failureCode.message}';
}
