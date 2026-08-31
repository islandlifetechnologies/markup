import 'markdown_section.dart';

/// A section of regular markdown content.
class MarkdownContent(
  super.contents, {
  required super.end,
  required super.start,
}) extends MarkdownSection;
