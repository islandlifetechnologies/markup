import 'dart:async';
import 'dart:convert';
import 'dart:io' show Process;

import 'package:markup/markup.dart';

part 'process_processor.g.dart';

typedef ProcessRunner = Future<String> Function({
  required List<String> args,
  required String command,
  required bool ignoreExitCode,
  required Logger logger,
  required MarkupSection section,
  required Duration timeout,
  required Directory workingDirectory,
});

class ProcessProcessor(
  super.directive, {
  required super.registry,
  final ProcessRunner runner = _defaultRunner,
  super.type = kType,
}) extends MarkupProcessor {
  this {
    final directive = section as MarkupDirective;
    _output = directive.output;
    _params = _Params.fromJson(directive.params);
  }
  static const kType = 'process';

  late final MarkupDirectiveOutput _output;
  late final _Params _params;

  static Future<String> _defaultRunner({
    required List<String> args,
    required String command,
    required bool ignoreExitCode,
    required Logger logger,
    required MarkupSection section,
    required Duration timeout,
    required Directory workingDirectory,
  }) async {
    final cl = [command, ...(args.map((a) => '"$a"'))].join(' ');
    logger.finer('Executing: $cl');
    final process = await Process.start(
      command,
      args,
      workingDirectory: workingDirectory.absolute.path,
    );

    final out = await utf8.decodeStream(process.stdout);
    final err = await utf8.decodeStream(process.stderr);
    if (logger.isLoggable(Level.FINEST)) {
      for (final (name, io) in [('stdio', out), ('stderr', err)]) {
        logger.finest('$name\n$io');
      }
    }

    final completer = Completer<int>();
    Future.delayed(timeout, () {
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

    final exitCode = await completer.future;
    if (exitCode != 0 && !ignoreExitCode) {
      throw MarkupException.fromSection(
        section,
        'Error executing: $cl',
        cause: process.stderr.toString(),
      );
    }

    return out;
  }

  @override
  Future<MarkupOutput> process(MarkdownDocument doc) async {
    final wd = getEntity<Directory>(doc, _params.workingDirectory);
    if (!wd.existsSync()) {
      throw MarkupException.fromSection(
        section,
        'Unable to locate working directory: ${wd.absolute.path}',
      );
    }
    final output = await _defaultRunner(
      args: _params.args,
      command: _params.command,
      ignoreExitCode: _params.ignoreExitCode,
      logger: logger,
      section: section,
      timeout: _params.timeout,
      workingDirectory: wd,
    );

    return MarkupOutput.fromSection(output, output: _output, section: section);
  }
}

@JsonSerializable()
class _Params({
  final List<String> args = const [],
  required final String command,
  @JsonKey(name: 'ignore-exit-code') final bool ignoreExitCode = false,
  @JsonKey(name: 'timeout', fromJson: JsonClass.parseDurationFromSeconds)
  final Duration timeout = const Duration(minutes: 1),
  @JsonKey(name: 'working-directory') final String workingDirectory = '.',
}) {
  factory fromJson(Map<String, dynamic> json) => _$ParamsFromJson(json);
}
