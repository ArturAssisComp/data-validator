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

  /// Enumeration for code 'unknown'
  unknown(
    message: 'Unknown excepction occurred.',
  );

  /// More detailed message describing the failure.
  final String message;
  const ValidationFailureCode({required this.message});
}

/// {@template ValidationFailure}
/// Thrown during the validation process if a failure occurs.
/// {@endtemplate}
class ValidationFailure implements Exception {
  /// The related [ValidationFailureCode] element that gives
  /// details about the error.
  final ValidationFailureCode failureCode;

  /// {@macro ValidationFailure}
  const ValidationFailure({this.failureCode = ValidationFailureCode.unknown});

  @override
  String toString() => 'ValidationFailure: ${failureCode.message}';
}
