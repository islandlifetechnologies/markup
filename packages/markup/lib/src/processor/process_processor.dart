import 'dart:io';

import 'package:json_annotation/json_annotation.dart';
import 'package:logging/logging.dart';

import '../../markup.dart';

part 'process_processor.g.dart';

typedef ProcessRunner = String Function({
  required List<String> args,
  required String command,
  required bool ignoreExitCode,
  required Logger logger,
  required MarkupSection section,
  required Directory workingDirectory,
});

class ProcessProcessor(
  super.directive, {
  final ProcessRunner runner = _defaultRunner,
  super.type = kType,
}) extends MarkupProcessor {
  this {
    _params = _Params.fromJson((section as MarkupDirective).params);
  }
  static const kType = 'process';

  late final _Params _params;

  static String _defaultRunner({
    required List<String> args,
    required String command,
    required bool ignoreExitCode,
    required Logger logger,
    required MarkupSection section,
    required Directory workingDirectory,
  }) {
    final cl = [command, ...(args.map((a) => '"$a"'))].join(' ');
    logger.finer('Executing: $cl');
    final process = Process.runSync(
      command,
      args,
      workingDirectory: workingDirectory.absolute.path,
    );

    if (logger.isLoggable(Level.FINEST)) {
      for (final (name, io) in [
        ('stdio', process.stdout?.toString()),
        ('stderr', process.stderr?.toString()),
      ]) {
        if (io != null) {
          logger.finest('$name\n$io');
        }
      }
    }

    if (process.exitCode != 0 && !ignoreExitCode) {
      throw MarkupException.fromSection(
        section,
        'Error executing: $cl',
        cause: process.stderr?.toString(),
      );
    }

    return process.stdout?.toString() ?? '';
  }

  @override
  MarkupOutput process(MarkdownDocument doc) {
    final wd = getEntity<Directory>(doc, _params.workingDirectory);
    if (!wd.existsSync()) {
      throw MarkupException.fromSection(
        section,
        'Unable to locate working directory: ${wd.absolute.path}',
      );
    }
    final output = _defaultRunner(
      args: _params.args,
      command: _params.command,
      ignoreExitCode: _params.ignoreExitCode,
      logger: logger,
      section: section,
      workingDirectory: wd,
    );

    return MarkupOutput.fromSection(output, section: section);
  }
}

@JsonSerializable()
class _Params({
  final List<String> args = const [],
  required final String command,
  @JsonKey(name: 'ignore-exit-code') final bool ignoreExitCode = false,
  @JsonKey(name: 'working-directory') final String workingDirectory = '.',
}) {
  factory fromJson(Map<String, dynamic> json) => _$ParamsFromJson(json);
}
