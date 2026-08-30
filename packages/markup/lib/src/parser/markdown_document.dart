import 'dart:collection';

import '../../markup.dart';

class MarkdownDocument(
  final List<MarkdownSection> _sections, {
  required final String outPath,
  required final String path,
  MarkupRegistry? registry,
}) extends ListBase<MarkdownSection> {
  this {
    _registry = registry ?? MarkupRegistry();
  }

  late final MarkupRegistry _registry;

  void insertAfter(MarkdownSection toLocate, MarkdownSection toInsert) {
    final index = _sections.indexOf(toLocate);
    _sections.insert(index + 1, toInsert);
  }

  @override
  MarkdownSection operator [](int index) => _sections[index];

  @override
  void operator []=(int index, MarkdownSection value) =>
      _sections[index] = value;

  @override
  int get length => _sections.length;

  List<MarkdownSection> get sections => List.from(_sections);

  @override
  set length(int newLength) =>
      throw Exception('Cannot change the length of MarkdownDocument');

  Future<MarkdownDocument> process() async {
    final result = <MarkdownSection>[];

    for (final section in _sections.where((s) => s is! MarkupOutput)) {
      result.add(section);
      if (section is MarkupDirective) {
        final processor = _registry.create(section);
        if (!processor.postProcessor) {
          final output = await processor.process(this);
          result.add(output);
        }
      }
    }

    final doc = MarkdownDocument(result, outPath: outPath, path: path);

    for (final section in _sections.where((s) => s is! MarkupOutput)) {
      if (section is MarkupDirective) {
        final processor = _registry.create(section);
        if (processor.postProcessor) {
          final output = await processor.process(doc);
          doc.insertAfter(section, output);
        }
      }
    }

    return doc;
  }

  @override
  String toString({bool ignoreOutput = false}) =>
      (ignoreOutput ? _sections.where((s) => s is! MarkupOutput) : _sections)
          .join('');
}
