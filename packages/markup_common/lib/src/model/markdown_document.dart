import 'package:markup_common/markup_common.dart';

part 'markdown_document.g.dart';

@JsonSerializable(explicitToJson: true)
class MarkdownDocument(
  List<MarkdownSection> sections, {
  required final String outPath,
  required final String path,
}) {
  this : _sections = sections;

  factory fromJson(Map<String, dynamic> json) =>
      _$MarkdownDocumentFromJson(json);

  final List<MarkdownSection> _sections;

  void insertAfter(MarkdownSection toLocate, MarkdownSection toInsert) {
    final index = _sections.indexOf(toLocate);
    _sections.insert(index + 1, toInsert);
  }

  MarkdownSection operator [](int index) => _sections[index];

  int get length => _sections.length;

  List<MarkdownSection> get sections => List.from(_sections);

  Future<MarkdownDocument> process(MarkupRegistry registry) async {
    final result = <MarkdownSection>[];

    for (final section in _sections.where((s) => s is! MarkupOutput)) {
      result.add(section);
      if (section is MarkupDirective) {
        final processor = registry.create(section);
        if (!processor.postProcessor) {
          final output = await processor.process(this);
          if (processor.replace) {
            result.removeLast();
          }
          result.add(output);
        }
      } else if (section is MarkupFence) {
        final processor = registry.maybeCreate(section);
        if (processor != null && !processor.postProcessor) {
          final output = await processor.process(this);
          if (processor.replace) {
            result.removeLast();
          }
          result.add(output);
        }
      }
    }

    final doc = MarkdownDocument(result, outPath: outPath, path: path);

    for (final section in _sections.where((s) => s is! MarkupOutput)) {
      if (section is MarkupDirective) {
        final processor = registry.create(section);
        if (processor.postProcessor) {
          final output = await processor.process(doc);
          doc.insertAfter(section, output);
        }
      }
    }

    return doc;
  }

  Map<String, dynamic> toJson() => _$MarkdownDocumentToJson(this);

  @override
  String toString({bool ignoreOutput = false}) =>
      (ignoreOutput ? _sections.where((s) => s is! MarkupOutput) : _sections)
          .map((s) => s.toString().trimRight())
          .join('\n');
}
