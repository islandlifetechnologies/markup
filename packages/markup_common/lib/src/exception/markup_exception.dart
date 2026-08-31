import 'package:markup_common/markup_common.dart';

class MarkupException(
  final String message, {
  required final int end,
  final Object? cause,
  final StackTrace? stackTrace,
  required final int start,
}) implements Exception {
  factory fromSection(
    MarkdownSection section,
    String message, {
    Object? cause,
    StackTrace? stackTrace,
  }) => MarkupException(
    message,
    cause: cause,
    end: section.end,
    stackTrace: stackTrace,
    start: section.start,
  );

  @override
  String toString() {
    final buf = StringBuffer();

    buf.writeln('[$start, $end]: $message');
    for (final o in [cause, stackTrace]) {
      buf.writeln(o.toString());
    }

    return buf.toString().trim();
  }
}
