import 'dart:io';

import 'package:markup/markup.dart';

typedef PluginRunner = String Function({
  required List<String> args,
  required String command,
  required bool ignoreExitCode,
  required Logger logger,
  required MarkupSection section,
  required Directory workingDirectory,
});

class MarkupPluginProcessor(
  super.section, {
  required final MarkupPluginData plugin,
  final PluginRunner runner = _defaultRunner,
  required super.type,
}) extends MarkupProcessor {
  this : super(postProcessor: plugin.postProcessor, replace: plugin.replace);

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
    final wd = getEntity<Directory>(doc, plugin.workingDirectory ?? '.');
    if (!wd.existsSync()) {
      throw MarkupException.fromSection(
        section,
        'Unable to locate working directory: ${wd.absolute.path}',
      );
    }
    final output = _defaultRunner(
      args: plugin.args,
      command: plugin.command,
      ignoreExitCode: plugin.ignoreExitCode,
      logger: logger,
      section: section,
      workingDirectory: wd,
    );

    return MarkupOutput.fromSection(output, section: section);
  }
}
