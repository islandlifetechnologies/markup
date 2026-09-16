import 'package:markup/markup.dart';
import 'package:markup/src/constant/pubspec.dart';
import 'package:test/test.dart';

void main() {
  initLogging(level: Level.ALL);
  final registry = DefaultMarkupRegistry();
  final scanner = MarkdownScanner.fromFile(
    registry.fs.file('test/assets/process.md'),
  );
  final doc = scanner.scan();

  test('process:1', () async {
    final directive = doc[1] as MarkupDirective;

    expect(directive.params['command'], 'dart');
    expect(directive.params['args'], ['bin/markup.dart', '--help']);
    expect(directive.params['working-directory'], r'${PWD}');

    final result = await ProcessProcessor(
      directive,
      registry: registry,
    ).process(doc);
    expect(result.content, '''
<!-- markup:output -->
markup ${kPubspec.version}

-c, --config     Configuration file for markup to use.
-i, --include    The search glob to find the file or files to modify.
-l, --log        Log level to use.
                 [ALL, FINEST, FINER, FINE, CONFIG, INFO, WARNING, SEVERE, SHOUT, OFF]
-o, --output     If set, all results will be written to this path and it's sub paths.
    --dry-run    Perform a dry run, print all the logs, but do not write any Markdown files.
    --help       Display this message.
    --version    Display version information.
<!-- /markup:output -->
''');
  });

  test('process:2', () async {
    final directive = doc[3] as MarkupDirective;

    expect(directive.params['command'], 'dart');
    expect(directive.params['args'], ['bin/markup.dart', '--version']);
    expect(directive.params['working-directory'], r'../../');

    final result = await ProcessProcessor(
      directive,
      registry: registry,
    ).process(doc);
    expect(result.content, '''
<!-- markup:output -->
markup ${kPubspec.version}
<!-- /markup:output -->
''');
  });
}
