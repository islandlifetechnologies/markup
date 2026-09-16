import 'dart:async';
import 'dart:convert';
import 'dart:io' show Process;

import 'package:markup/markup.dart';

typedef PluginRunner = Future<String> Function({
  required MarkdownDocument doc,
  required Logger logger,
  required MarkupPluginData plugin,
  required MarkupSection section,
});

class PluginProcessor(
  super.directive, {
  required final MarkupPluginData plugin,
  required super.registry,
  final PluginRunner runner = _defaultRunner,
  super.type = kType,
}) extends MarkupProcessor {
  this : super(postProcessor: plugin.postProcessor, replace: plugin.replace);

  static const kType = 'plugin';

  static Future<String> _defaultRunner({
    required MarkdownDocument doc,
    required Logger logger,
    required MarkupPluginData plugin,
    required MarkupSection section,
  }) async {
    final cl = [plugin.command, ...(plugin.args.map((a) => '"$a"'))].join(' ');
    logger.finer('Executing: $cl');
    final process = await Process.start(
      plugin.command,
      plugin.args,
      runInShell: true,
    );
    try {
      final input = MarkupPluginInput(doc: doc, section: section);

      final inData = json.encode(input.toJson());

      logger.finest('Passing input to plugin: ${plugin.command}\n$inData');
      process.stdin.write(inData);
      await process.stdin.flush();
      await process.stdin.close();

      final completer = Completer<int>();

      Future.delayed(plugin.timeout, () {
        if (!completer.isCompleted) {
          completer.completeError('Timeout!');
        }
      });

      // ignore: unawaited_futures
      process.exitCode.then((c) {
        if (!completer.isCompleted) {
          completer.complete(c);
        }
      });

      logger.info('Waiting for plugin: ${plugin.command}');
      final exitCode = await completer.future;

      if (exitCode != 0 && !plugin.ignoreExitCode) {
        throw MarkupException.fromSection(
          section,
          'Error executing: $cl',
          cause: await utf8.decodeStream(process.stderr),
        );
      }

      final result = await utf8.decodeStream(process.stdout);

      return result;
    } on MarkupException catch (_) {
      rethrow;
    } catch (e, stack) {
      throw MarkupException.fromSection(
        section,
        'Error executing plugin: ${plugin.command}',
        cause: e,
        stackTrace: stack,
      );
    }
  }

  @override
  Future<MarkupOutput> process(MarkdownDocument doc) async {
    final output = await _defaultRunner(
      doc: doc,
      logger: logger,
      plugin: plugin,
      section: section,
    );

    return MarkupOutput(output, end: section.end, start: section.start);
  }
}
