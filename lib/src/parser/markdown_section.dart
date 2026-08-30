import 'package:markup/markup.dart';

typedef SectionBuilder = MarkdownSection Function(String contents);

abstract class MarkdownSection(
  final String contents, {
  required final int end,
  required final int start,
}) {
  MarkupException toException(
    String message, [
    Object? cause,
    StackTrace? stackTrace,
  ]) => MarkupException(
    message,
    cause: cause,
    end: end,
    start: start,
    stackTrace: stackTrace,
  );

  @override
  String toString() => contents;
}
