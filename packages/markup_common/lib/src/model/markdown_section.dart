import 'package:markup_common/markup_common.dart';

/// Abstract class for separating content within a Markdown document.
abstract class MarkdownSection(
  final String content, {

  /// The line number of the end of the section in the original document.
  required final int end,

  required final String sectionType,

  /// The line number for the start of the section in the original document.
  required final int start,
}) {
  factory fromJson(Map<String, dynamic> json) => switch (json['sectionType']) {
    MarkdownContent.kSectionType => MarkdownContent.fromJson(json),
    MarkupDirective.kSectionType => MarkupDirective.fromJson(json),
    MarkupFence.kSectionType => MarkupFence.fromJson(json),
    MarkupIgnore.kSectionType => MarkupIgnore.fromJson(json),
    MarkupOutput.kSectionType => MarkupOutput.fromJson(json),

    // Defaults to the safest option to use when otherwise unknown
    _ => MarkdownContent.fromJson(json),
  };

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

  Map<String, dynamic> toJson();

  /// Returns the contents of the section that can be embedded into a Markdown
  /// file.
  @override
  String toString() => content;
}
