import 'package:markup/markup.dart';
import 'package:test/test.dart';

void main() {
  final registry = DefaultMarkupRegistry();
  final scanner = MarkdownScanner.fromFile(
    registry.fs.file('test/assets/drawio.md'),
  );
  final doc = scanner.scan();

  test('drawio:1', () async {
    final directive = doc[0] as MarkupDirective;

    expect(directive.params['file'], 'drawio/infographic.drawio');
    expect(directive.params['mode'], 'svg');

    final result = DrawIoProcessor(directive, registry: registry).process(doc);
    expect(result.content, '''
<!-- markup:output -->
![drawio/infographic-1.svg](drawio/infographic-1.svg)
<!-- /markup:output -->
''');
  });

  test('drawio:2', () async {
    final directive = doc[2] as MarkupDirective;

    expect(
      directive.params['file'],
      r'${PWD}/test/assets/drawio/infographic.drawio',
    );
    expect(directive.params['index'], 2);
    expect(directive.params['label'], 'Why Agile Swirly Thing');
    expect(directive.params['mode'], 'png');

    final result = DrawIoProcessor(directive, registry: registry).process(doc);
    expect(result.content, '''
<!-- markup:output -->
![Why Agile Swirly Thing](drawio/infographic-2.png)
<!-- /markup:output -->
''');
  });
}
