/// Returns true if [l1] is equal to [l2]. Otherwise, it returns false.
///
/// This function check if the runtime type is the same if they are dynamic.
/// If they have the same type, they will be compared for each element using
/// the operator ==, thus, it is very important that the objects of the list
/// have the implementation of == and hash.
///
/// ## Parameters
/// ### Positional Parameters
/// - List<T> l1, l2: the lists that will be compared for equality.
bool listEquality<T>(List<T> l1, List<T> l2) {
  if (identical(l1, l2)) {
    return true;
  }
  if (l1.runtimeType != l2.runtimeType) {
    return false;
  }
  if (l1.isEmpty && l2.isEmpty) {
    return true;
  }
  if (l1.length != l2.length) {
    return false;
  }

  for (var i = 0; i < l1.length; i++) {
    if (l1[i] != l2[i]) {
      return false;
    }
  }
  return true;
}
