import 'dart:io';

import 'package:markup/src/parser/markdown_content.dart';
import 'package:markup/src/parser/markdown_scanner.dart';
import 'package:markup/src/parser/markup_directive.dart';
import 'package:test/test.dart';

void main() {
  test('simple', () {
    final markdown = File('test/assets/toc.md').readAsStringSync();
    final scanner = MarkdownScanner(markdown);

    final doc = scanner.scan();

    expect(doc.length, 9);

    expect(doc[0], isA<MarkdownContent>());
    expect(doc[1], isA<MarkupDirective>());
    expect((doc[1] as MarkupDirective).contents, '<!-- markup:toc /-->');
    expect((doc[1] as MarkupDirective).params, {});
    expect(doc[2], isA<MarkdownContent>());
    expect(doc[3], isA<MarkupDirective>());
    expect(
      (doc[3] as MarkupDirective).contents,
      '<!-- markup:toc {"bullet": "+"} /-->',
    );
    expect((doc[3] as MarkupDirective).params, {'bullet': '+'});
    expect(doc[4], isA<MarkdownContent>());
    expect(doc[5], isA<MarkupDirective>());
    expect(
      (doc[5] as MarkupDirective).contents,
      '<!-- markup:toc\n'
      '{\n'
      '  "bullet": "*"\n'
      '}\n'
      '/-->\n',
    );
    expect((doc[5] as MarkupDirective).params, {'bullet': '*'});
    expect(doc[6], isA<MarkdownContent>());
    expect(doc[7], isA<MarkupDirective>());
    expect(
      (doc[7] as MarkupDirective).contents,
      '<!-- markup:toc\n'
      '\n'
      '# YAML\n'
      "bullet: '*'\n"
      '\n'
      '/-->\n',
    );
    expect((doc[7] as MarkupDirective).params, {'bullet': '*'});
    expect(doc[8], isA<MarkdownContent>());
  });
}
