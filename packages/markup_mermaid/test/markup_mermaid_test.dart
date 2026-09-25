import 'dart:io';

import 'package:markup/src/main.dart' as m;
import 'package:markup_common/markup_common.dart';
import 'package:test/test.dart';

void main() {
  initLogging(level: Level.ALL);
  final registry = MarkupRegistry();

  test('mermaid via markup', () async {
    final config = registry.fs.file('output/markup.yaml');
    if (!config.existsSync()) {
      config.createSync(recursive: true);
    }
    config.writeAsStringSync(r'''
include: test/assets/mermaid.md
log: FINEST
output: output/

plugins:
  mermaid:
    command: dart
    args:
      - bin/markup_mermaid.dart
      - --log
      - FINEST
      - --log-file
      - output/output.log
    replace: true
''');

    await m.main(['-c', 'output/markup.yaml'], allowExit: false);

    expect(exitCode, 0);
  });
}
