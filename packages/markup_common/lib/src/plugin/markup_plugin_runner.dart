// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:markup_common/markup_common.dart';

class MarkupPluginRunner {
  Future<void> execute({required MarkupRegistry registry}) async {
    try {
      final ins = await stdin.transform(utf8.decoder).join();
      stderr.writeln('Received\n$ins');
      final input = MarkupPluginInput.fromJson(json.decode(ins));
      final processor = registry.create(input.section);
      final result = await processor.process(input.doc);

      stdout.write(result);
      await stdout.flush();
      await stdout.close();

      exit(0);
    } catch (e, stack) {
      stderr.writeln('Error!\n$e\n$stack');
      await stderr.flush();
      await stderr.close();
      exit(1);
    }
  }
}
