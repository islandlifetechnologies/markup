import 'markdown_section.dart';

abstract class MarkupSection(
  super.contents, {
  required super.start,
  required super.end,
}) extends MarkdownSection {
  String get type;
}
