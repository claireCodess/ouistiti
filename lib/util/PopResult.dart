// From https://github.com/nguyentuanhung/flutter_popuntil/blob/master/flutter_popuntil/lib/pop_result.dart

import 'package:meta/meta.dart';

/// PopResult
class PopWithResults<T> {
  /// poped from this page
  final String fromPage;

  /// pop until this page
  final String toPage;

  /// results
  final Map<String, T> results;

  /// constructor
  PopWithResults(
      {@required this.fromPage, @required this.toPage, this.results});
}
