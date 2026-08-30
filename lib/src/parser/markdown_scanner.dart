import 'dart:io';

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

  MarkdownDocument scan() {
    final scanner = StringScanner.fromString(input);

    final sections = <MarkdownSection>[];

    var buf = StringBuffer();
    int? startNum;

    void stashBuffer() {
      if (buf.isNotEmpty) {
        sections.add(
          MarkdownContent(
            buf.toString(),
            end: scanner.offset,
            start: startNum!,
          ),
        );
        buf = StringBuffer();
      }
    }

    for (final line in scanner) {
      startNum ??= scanner.offset;

      final markupBlockMatch = markupBlockRegEx.firstMatch(line);
      final markupMatch = markupBlockMatch != null
          ? null
          : markupRegEx.firstMatch(line);

      if (markupBlockMatch != null) {
        stashBuffer();
        final key = markupBlockMatch.namedGroup('key')!;
        sections.add(_readMarkupBlock(scanner, key));
      } else if (markupMatch != null) {
        stashBuffer();
        sections.add(_readMarkupDirective(scanner));
      } else {
        buf.writeln(line);
      }
    }

    if (buf.isNotEmpty) {
      sections.add(
        MarkdownContent(
          buf.toString(),
          end: scanner.offset,
          start: startNum ?? 0,
        ),
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

    return MarkupDirective(
      buf.toString(),
      end: scanner.offset,
      start: startNum,
    );
  }
}
