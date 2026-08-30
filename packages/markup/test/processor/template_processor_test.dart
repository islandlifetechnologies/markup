import 'dart:io';

import 'package:markup/markup.dart';
import 'package:markup/src/constant/pubspec.dart';
import 'package:test/test.dart';

void main() {
  final scanner = MarkdownScanner.fromFile(File('test/assets/template.md'));
  final doc = scanner.scan();

  test('template:0', () async {
    final directive = doc[0] as MarkupDirective;

    expect(
      directive.params['template'],
      r'The answer to life is: ${20 * 2 + 2}',
    );

    final result = TemplateProcessor(directive).process(doc);
    expect(result.contents, '''
<!-- markup:output -->
The answer to life is: 42
<!-- /markup:output -->
''');
  });

  test('template:2', () async {
    final directive = doc[2] as MarkupDirective;

    expect(directive.params['context'], {
      'pubspec': r"${yaon.decode(File('pubspec.yaml').readAsStringSync())}",
    });

    final result = TemplateProcessor(directive).process(doc);
    expect(result.contents, '''
<!-- markup:output -->
```yaml
dependencies:
  markup: ^${kPubspec.version}
```
<!-- /markup:output -->
''');
  });
}
