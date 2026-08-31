import 'markdown_section.dart';

/// An abstract section that is known to the markup platform for special
/// handling.
abstract class MarkupSection(
  super.contents, {
  required super.end,
  required super.start,
}) extends MarkdownSection {
  String get type;
}
