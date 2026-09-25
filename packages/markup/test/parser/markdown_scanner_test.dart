import 'package:markup/markup.dart';
import 'package:test/test.dart';

void main() {
  initLogging(level: Level.ALL);
  test('simple', () {
    final registry = DefaultMarkupRegistry();
    final markdown = registry.fs.file('test/assets/toc.md').readAsStringSync();
    final scanner = MarkdownScanner(markdown);

    final doc = scanner.scan(registry: registry);

    expect(doc.length, 13);

    expect(doc[0], isA<MarkdownContent>());
    expect(doc[1], isA<MarkupDirective>());
    expect((doc[1] as MarkupDirective).content, '<!-- markup:toc /-->');
    expect((doc[1] as MarkupDirective).params, {});
    expect(doc[2], isA<MarkdownContent>());
    expect(doc[3], isA<MarkupDirective>());
    expect(
      (doc[3] as MarkupDirective).content,
      '<!-- markup:toc {"bullet": "+"} /-->',
    );
    expect((doc[3] as MarkupDirective).params, {'bullet': '+'});
    expect(doc[4], isA<MarkdownContent>());
    expect(doc[5], isA<MarkupDirective>());
    expect(
      (doc[5] as MarkupDirective).content,
      '<!-- markup:toc\n'
      '{\n'
      '  "bullet": "*"\n'
      '}\n'
      '/-->\n\n',
    );
    expect((doc[5] as MarkupDirective).params, {'bullet': '*'});
    expect(doc[6], isA<MarkdownContent>());
    expect(doc[7], isA<MarkupDirective>());
    expect(
      (doc[7] as MarkupDirective).content,
      '<!-- markup:toc\n'
      '\n'
      '# YAML\n'
      "bullet: '*'\n"
      '\n'
      '/-->\n\n',
    );
    expect((doc[7] as MarkupDirective).params, {'bullet': '*'});
    expect(doc[8], isA<MarkdownContent>());
    expect(doc[9], isA<MarkupIgnore>());
    expect((doc[9] as MarkupIgnore).content, '''
<!-- markup:ignore -->

## Repeat

<!-- /markup:ignore -->
''');
    expect(doc[10], isA<MarkdownContent>());
    expect(doc[11], isA<MarkupOutput>());
    expect((doc[11] as MarkupOutput).content, '''
<!-- markup:output -->

### Repeat

<!-- /markup:output -->
''');
    expect(doc[12], isA<MarkdownContent>());
  });

  test('fence', () {
    final registry = DefaultMarkupRegistry();
    registry
      ..registerBuilder('dart', (section, {required registry}) {
        throw UnimplementedError();
      })
      ..registerBuilder('markdown', (section, {required registry}) {
        throw UnimplementedError();
      })
      ..registerBuilder('mermaid', (section, {required registry}) {
        throw UnimplementedError();
      })
      ..registerBuilder('yaml', (section, {required registry}) {
        throw UnimplementedError();
      });
    final markdown = registry.fs
        .file('test/assets/fence.md')
        .readAsStringSync();
    final scanner = MarkdownScanner(markdown);

    final doc = scanner.scan(registry: registry);

    expect(doc.length, 9);
    expect(doc[0], isA<MarkdownContent>());
    expect(doc[1], isA<MarkupFence>());
    expect((doc[1] as MarkupFence).type, 'dart');
    expect((doc[1] as MarkupFence).content, '''
```dart
class Foo {}
```
''');
    expect((doc[1] as MarkupFence).indent, 0);
    expect(doc[2], isA<MarkdownContent>());
    expect(doc[3], isA<MarkupFence>());
    expect((doc[3] as MarkupFence).type, 'markdown');
    expect((doc[3] as MarkupFence).content, '''
````markdown
And here is another example...

```dart
print('Hello')
```
````
''');
    expect((doc[3] as MarkupFence).indent, 0);
    expect(doc[4], isA<MarkdownContent>());
    expect(doc[5], isA<MarkupFence>());
    expect((doc[5] as MarkupFence).type, 'yaml');
    expect((doc[5] as MarkupFence).content, '''
  ```yaml
  # This is associated with the bullet
  ```
''');
    expect((doc[5] as MarkupFence).indent, 2);
    expect((doc[5] as MarkupFence).withoutIndent, '''
```yaml
# This is associated with the bullet
```
''');
    expect(doc[8], isA<MarkdownContent>());
    expect(doc[7], isA<MarkupFence>());
    expect((doc[7] as MarkupFence).type, 'mermaid');
    expect((doc[7] as MarkupFence).content, '''
```mermaid
graph LR
    A[Square Rect] -- Link text --> B((Circle))
    A --> C(Round Rect)
    B --> D{Rhombus}
    C --> D
```
''');
    expect(doc[8], isA<MarkdownContent>());
  });
}
