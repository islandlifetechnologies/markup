import 'dart:io';

import 'package:markup/markup.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  test('full_processor', () async {
    final output = Directory('test/output');
    if (output.existsSync()) {
      output.deleteSync(recursive: true);
    }
    output.createSync(recursive: true);
    final scanner = MarkdownScanner.fromFile(
      File('test/assets/full_processing.md'),
      output: output,
    );
    final doc = scanner.scan();
    final result = await doc.process();

    File(p.join(output.path, 'full_processing.md'))
      ..createSync(recursive: true)
      ..writeAsStringSync(result.toString());
  });
}
