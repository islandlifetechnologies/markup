import 'package:markup/markup.dart';

class MarkdownScanner(
  final String input, {
  final String outPath = '.',
  final String path = '.',
}) {
  factory fromFile(File file, {Directory? output}) => MarkdownScanner(
    file.readAsStringSync(),
    outPath: output == null ? file.parent.absolute.path : output.absolute.path,
    path: file.absolute.path,
  );

  static final markupBlockRegEx = RegExp(
    r'<!--\s*markup:(?<key>(ignore|output))',
  );
  static final markupBlockEndRegEx = RegExp(
    r'<!--\s*/markup:(?<key>(ignore|output))',
  );
  static final markupRegEx = RegExp(r'^<!--\s*markup:');

  MarkdownDocument scan({required MarkupRegistry registry}) {
    final scanner = StringScanner.fromString(input);

    final sections = <MarkdownSection>[];

    var buf = StringBuffer();

    void stashBuffer(int startNum) {
      if (buf.isNotEmpty) {
        sections.add(
          MarkdownContent(buf.toString(), end: scanner.offset, start: startNum),
        );
        buf = StringBuffer();
      }
    }

    var startNum = 0;
    for (final line in scanner) {
      final fenceBlock = MarkupFence.fenceRegEx.firstMatch(line.trim());
      final markupBlockMatch = fenceBlock != null
          ? null
          : markupBlockRegEx.firstMatch(line);
      final markupMatch = fenceBlock != null || markupBlockMatch != null
          ? null
          : markupRegEx.firstMatch(line);

      if (fenceBlock != null &&
          registry.canProcess(fenceBlock.namedGroup('type'))) {
        stashBuffer(startNum);
        startNum = scanner.offset;
        final fence = fenceBlock.namedGroup('fence')!;
        sections.add(_readMarkupFence(scanner, fence));
      } else if (markupBlockMatch != null) {
        stashBuffer(startNum);
        startNum = scanner.offset;
        final key = markupBlockMatch.namedGroup('key')!;
        sections.add(_readMarkupBlock(scanner, key));
      } else if (markupMatch != null) {
        stashBuffer(startNum);
        startNum = scanner.offset;
        sections.add(_readMarkupDirective(scanner));
      } else {
        buf.writeln(line);
      }
    }

    if (buf.isNotEmpty) {
      sections.add(
        MarkdownContent(buf.toString(), end: scanner.offset, start: startNum),
      );
    }

    return MarkdownDocument(sections, outPath: outPath, path: path);
  }

  MarkupSection _readMarkupBlock(StringScanner scanner, String key) {
    final endRegEx = RegExp(r'<!--\s*/markup:' + key);

    final startLine = scanner.iterator.current;
    final startNum = scanner.offset;
    final buf = StringBuffer();
    buf.writeln(startLine);

    for (final line in scanner) {
      buf.writeln(line);
      if (endRegEx.hasMatch(line)) {
        break;
      }
    }

    return switch (key) {
      'ignore' => MarkupIgnore(
        buf.toString(),
        end: scanner.offset,
        start: startNum,
      ),
      'output' => MarkupOutput(
        buf.toString(),
        end: scanner.offset,
        start: startNum,
      ),
      _ => throw Exception('Unknown markup block key: $key'),
    };
  }

  MarkupSection _readMarkupDirective(StringScanner scanner) {
    final endRegEx = RegExp(r'\s*-->');

    final startLine = scanner.iterator.current;
    final startNum = scanner.offset;
    if (endRegEx.hasMatch(startLine)) {
      return MarkupDirective(startLine, end: scanner.offset, start: startNum);
    }

    final buf = StringBuffer();
    buf.writeln(startLine);

    for (final line in scanner) {
      buf.writeln(line);
      if (endRegEx.hasMatch(line)) {
        break;
      }
    }

    return MarkupDirective('$buf\n', end: scanner.offset, start: startNum);
  }

  MarkupSection _readMarkupFence(StringScanner scanner, String fence) {
    final startLine = scanner.iterator.current;
    final startNum = scanner.offset;
    final buf = StringBuffer();
    buf.writeln(startLine);

    for (final line in scanner) {
      buf.writeln(line);

      final match = MarkupFence.fenceRegEx.firstMatch(line.trim());
      if (match?.namedGroup('fence')?.length == fence.length) {
        break;
      }
    }
    return MarkupFence(buf.toString(), end: scanner.offset, start: startNum);
  }
}
