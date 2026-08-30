import 'dart:io';

import 'package:markup/markup.dart';
import 'package:markup/src/constant/pubspec.dart';
import 'package:test/test.dart';

void main() {
  final scanner = MarkdownScanner.fromFile(File('test/assets/process.md'));
  final doc = scanner.scan();

  test('process:1', () async {
    final directive = doc[1] as MarkupDirective;

    expect(directive.params['command'], 'dart');
    expect(directive.params['args'], ['bin/markup.dart', '--help']);
    expect(directive.params['working-directory'], r'${PWD}');

    final result = ProcessProcessor(directive).process(doc);
    expect(result.contents, '''
<!-- markup:output -->
markup ${kPubspec.version}

-i, --include    The search glob to find the file or files to modify.
                 (defaults to "**/*.md")
-o, --output     If set, all results will be written to this path and it's sub paths.
    --help       Display this message
    --version    Display version information
<!-- /markup:output -->
''');
  });

  test('process:2', () async {
    final directive = doc[3] as MarkupDirective;

    expect(directive.params['command'], 'dart');
    expect(directive.params['args'], ['bin/markup.dart', '--version']);
    expect(directive.params['working-directory'], r'../../');

    final result = ProcessProcessor(directive).process(doc);
    expect(result.contents, '''
<!-- markup:output -->
markup ${kPubspec.version}
<!-- /markup:output -->
''');
  });
}
