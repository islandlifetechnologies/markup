import 'package:markup_common/markup_common.dart';
import 'package:markup_mermaid/src/mermaid_processor.dart';
import 'package:test/test.dart';

void main() {
  initLogging(level: Level.ALL);
  final registry = MarkupRegistry();

  test('processor', () async {
    const flowDiagram = '''
```mermaid {"title": "Flow Diagram"}
graph LR
    A[Square Rect] -- Link text --> B((Circle))
    A --> C(Round Rect)
    B --> D{Rhombus}
    C --> D
```
''';
    final section = MarkupFence(flowDiagram, end: 0, start: 0);
    final processor = MermaidProcessor(
      section,
      registry: registry,
      type: 'mermaid',
    );

    final output = await processor.process(
      MarkdownDocument([section], outPath: 'output', path: 'mermaid-flow.md'),
    );

    expect(output.content, '''
<!-- markup:output -->
![Flow Diagram](../output/mermaid-4410b7a3cd3aa57c07c29be97b25800ad886fcfc31f0173d9720de5d0bccb109.svg)
<!-- /markup:output -->
''');
  });
}
