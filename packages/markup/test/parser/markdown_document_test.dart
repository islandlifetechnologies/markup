import 'package:markup/markup.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  initLogging(level: Level.ALL);

  test('full_processor', () async {
    final registry = DefaultMarkupRegistry();
    final output = registry.fs.directory('test/output');
    if (output.existsSync()) {
      output.deleteSync(recursive: true);
    }
    output.createSync(recursive: true);
    final scanner = MarkdownScanner.fromFile(
      registry.fs.file('test/assets/full_processing.md'),
      output: output,
    );
    final doc = scanner.scan(registry: registry);
    final result = await doc.process(DefaultMarkupRegistry());

    registry.fs.file(p.join(output.path, 'full_processing.md'))
      ..createSync(recursive: true)
      ..writeAsStringSync(result.toString());
  });

  test('decode', () {
    final doc = MarkdownDocument.fromJson(_kExampleDoc);

    expect(doc.sections.length, 7);
    expect(doc[0], isA<MarkdownContent>());
    expect(doc[1], isA<MarkupFence>());
    expect(doc[2], isA<MarkdownContent>());
    expect(doc[3], isA<MarkupFence>());
    expect(doc[4], isA<MarkdownContent>());
    expect(doc[5], isA<MarkupFence>());
    expect(doc[6], isA<MarkdownContent>());
  });
}

const _kExampleDoc = {
  'outPath': '/Users/jpeiffer/git/ilt/markup/packages/markup/../markup_mermaid/output/../markup_mermaid/test/assets',
  'path': '/Users/jpeiffer/git/ilt/markup/packages/markup/./../markup_mermaid/test/assets/mermaid.md',
  'sections': [
    {
      'content': '## Mermaid\n\n',
      'end': 2,
      'sectionType': 'MarkdownContent',
      'start': 0,
    },
    {
      'content': '```mermaid\ngraph LR\n    A[Square Rect] -- Link text --> B((Circle))\n    A --> C(Round Rect)\n    B --> D{Rhombus}\n    C --> D\n```\n',
      'end': 8,
      'sectionType': 'MarkupFence',
      'start': 2,
    },
    {'content': '\n', 'end': 10, 'sectionType': 'MarkdownContent', 'start': 2},
    {
      'content': '```mermaid type: svg\n---\ntitle: Animal example\n---\nclassDiagram\n    note "From Duck till Zebra"\n    Animal <|-- Duck\n    note for Duck "can fly<br>can swim<br>can dive<br>can help in debugging"\n    Animal <|-- Fish\n    Animal <|-- Zebra\n    Animal : +int age\n    Animal : +String gender\n    Animal: +isMammal()\n    Animal: +mate()\n    class Duck{\n        +String beakColor\n        +swim()\n        +quack()\n    }\n    class Fish{\n        -int sizeInFeet\n        -canEat()\n    }\n    class Zebra{\n        +bool is_wild\n        +run()\n    }\n```\n',
      'end': 37,
      'sectionType': 'MarkupFence',
      'start': 10,
    },
    {'content': '\n', 'end': 39, 'sectionType': 'MarkdownContent', 'start': 10},
    {
      'content': '```mermaid {"type": "png", "backgroundColor": "#000", "width": 800}\nflowchart TD\n    Start --> Stop\n```\n',
      'end': 42,
      'sectionType': 'MarkupFence',
      'start': 39,
    },
    {'content': '\n', 'end': 44, 'sectionType': 'MarkdownContent', 'start': 39},
  ],
};
