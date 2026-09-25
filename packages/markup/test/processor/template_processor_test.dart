import 'package:markup/markup.dart';
import 'package:markup/src/constant/pubspec.dart';
import 'package:test/test.dart';

void main() {
  initLogging(level: Level.ALL);
  final registry = DefaultMarkupRegistry();
  final scanner = MarkdownScanner.fromFile(
    registry.fs.file('test/assets/template.md'),
  );
  final doc = scanner.scan(registry: registry);

  test('template:0', () async {
    final directive = doc[0] as MarkupDirective;

    expect(
      directive.params['template'],
      r'The answer to life is: ${20 * 2 + 2}',
    );

    final result = TemplateProcessor(
      directive,
      registry: registry,
    ).process(doc);
    expect(result.content, '''
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

    final result = TemplateProcessor(
      directive,
      registry: registry,
    ).process(doc);
    expect(result.content, '''
<!-- markup:output -->
```yaml
dependencies:
  markup: ^${kPubspec.version}
```
<!-- /markup:output -->
''');
  });
}
