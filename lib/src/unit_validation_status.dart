/// Enum defining the possible outcomes of a unit validation process.
///
/// Each value represents a different state of validation for a specific node
/// (unit) in the validation pipeline, providing clear status feedback for that
/// particular unit.
enum UnitValidationStatusCode {
  /// Indicates the validation was successful and the data meets all criteria
  /// for this unit.
  success(defaultDescription: 'Target validation data is valid.'),

  /// Indicates the validation failed due to the data not meeting certain
  /// criteria specific to this unit.
  failed(defaultDescription: 'Target validation data is not valid.'),

  /// Indicates the validation resulted in a warning for this unit, suggesting
  /// potential issues that may not necessarily fail the validation but should
  /// be noted.
  warning(
    defaultDescription:
        'Target validation data is valid, but there are potential issues.',
  ),

  /// Indicates that the validation status for this unit has not yet been
  /// determined or is pending. This status is used when the validation process
  /// for this unit has not been completed or not executed yet.
  notDefined(
    defaultDescription: 'Target validation data is not validated yet.',
  );

  /// This description is used as default if no more detailed description is
  /// provided.
  final String defaultDescription;
  const UnitValidationStatusCode({required this.defaultDescription});
}

/// {@template UnitValidationStatus}
/// Represents the outcome of executing a validation rule on a target object for
/// a specific unit.
///
/// This class encapsulates the status of a validation operation for a single
/// node (unit) in the validation pipeline, providing essential information
/// about the outcome and status of that specific validation node.
/// {@endtemplate}
final class UnitValidationStatus {
  /// The name of the validation node. It should be descriptive and indicative
  /// of the kind of validation being performed in the related step.
  final String nodeName;

  /// The status code of the validation operation for this node.
  ///
  /// It reflects the current status of the validation process for this unit,
  /// such as success, failure, warning, or not yet defined, providing immediate
  /// insight into the outcome for this specific validation step.
  final UnitValidationStatusCode status;

  /// Description of the validation status for this node, potentially including
  /// reasons for failure or details of the warning.
  ///
  /// This message provides additional context to the `status`, offering
  /// insights into why a particular validation for this node passed or failed.
  final String description;

  /// Constructs a [UnitValidationStatus] with the given parameters.
  ///
  /// ## Parameters:
  /// - `nodeName`: The name of the node in the validation pipeline.
  /// - `status`: The validation status code for this node.
  /// - `description`: (Optional) A descriptive message about the validation
  /// status for this node.
  ///
  /// {@macro UnitValidationStatus}
  const UnitValidationStatus({
    required this.nodeName,
    required this.status,
    this.description = '',
  });

  /// Creates a copy of the current instance, replacing only the provided
  /// parameters. Useful for creating modified versions of the status without
  /// altering the other attributes.
  UnitValidationStatus copyOf({
    String? nodeName,
    UnitValidationStatusCode? status,
    String? description,
  }) =>
      UnitValidationStatus(
        nodeName: nodeName ?? this.nodeName,
        status: status ?? this.status,
        description: description ?? this.description,
      );

  @override
  String toString() => '$nodeName: ${status.name}';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is UnitValidationStatus) {
      return nodeName == other.nodeName &&
          status == other.status &&
          description == other.description &&
          runtimeType == other.runtimeType;
    }
    return false;
  }

  @override
  int get hashCode => Object.hash(nodeName, status, description);
}
