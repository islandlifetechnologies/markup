import '../../markup.dart';

class MarkupOutput(super.contents, {required super.end, required super.start})
    extends MarkupSection {
  factory fromSection(
    String contents, {
    required MarkdownSection section,
  }) => MarkupOutput(
    '\n<!-- markup:output -->\n${contents.trim()}\n<!-- /markup:output -->\n',
    end: section.start + 1 + contents.split('\n').length,
    start: section.start + 1,
  );

  @override
  String get type => 'output';
}
