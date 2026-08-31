import 'dart:io';

import 'package:markup/markup.dart';
import 'package:test/test.dart';

void main() {
  test('simple', () {
    final markdown = File('test/assets/toc.md').readAsStringSync();
    final scanner = MarkdownScanner(markdown);

    final doc = scanner.scan();

    expect(doc.length, 13);

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
    expect(doc[9], isA<MarkupIgnore>());
    expect((doc[9] as MarkupIgnore).contents, '''
<!-- markup:ignore -->

## Repeat

<!-- /markup:ignore -->
''');
    expect(doc[10], isA<MarkdownContent>());
    expect(doc[11], isA<MarkupOutput>());
    expect((doc[11] as MarkupOutput).contents, '''
<!-- markup:output -->

### Repeat

<!-- /markup:output -->
''');
    expect(doc[12], isA<MarkdownContent>());
  });
}
