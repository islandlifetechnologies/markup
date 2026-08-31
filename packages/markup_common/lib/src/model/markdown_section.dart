import 'package:markup_common/markup_common.dart';

/// Abstract class for separating content within a Markdown document.
abstract class MarkdownSection(
  final String contents, {

  /// The line number of the end of the section in the original document.
  required final int end,

  /// The line number for the start of the section in the original document.
  required final int start,
}) {
  /// Constructs an exception that contains the positional information from this
  /// section.
  MarkupException toException(
    String message, [
    Object? cause,
    StackTrace? stackTrace,
  ]) => MarkupException.fromSection(
    this,
    message,
    cause: cause,
    stackTrace: stackTrace,
  );

  /// Returns the contents of the section that can be embedded into a Markdown
  /// file.
  @override
  String toString() => contents;
}
