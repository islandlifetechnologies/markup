import 'dart:io';

import 'package:markup_common/markup_common.dart';
import 'package:markup_mermaid/src/example_plugin.dart';
import 'package:markup_mermaid/src/mermaid_processor.dart';
import 'package:markup_mermaid/src/pubspec.dart';

void main(List<String> args) async {
  final parsed = MarkupPluginArgs().process(
    args,
    exampleConfig: examplePlugin,
    parser: ArgParser()
      ..addOption(
        'type',
        defaultsTo: 'mermaid',
        help: 'The type or key for the markup processor',
      ),
    version: pubspec.version,
  );

  _verifyMmdc();

  final runner = MarkupPluginRunner();

  await runner.execute(
    registry: MarkupRegistry(
      builders: {
        parsed['type']: (section, {required registry}) =>
            MermaidProcessor(section, registry: registry, type: parsed['type']),
      },
    ),
  );
}

void _verifyMmdc() {
  final logger = Logger('main');
  var mmdcInstalled = false;
  try {
    final result = Process.runSync('mmdc', ['--version']);
    if (result.exitCode == 0) {
      mmdcInstalled = true;
    }
  } catch (e) {
    // no-op
  }

  if (!mmdcInstalled) {
    try {
      logger.info('mmdc not installed, attempting to install');
      final result = Process.runSync('npm', [
        'install',
        '-g',
        '@mermaid-js/mermaid-cli',
      ]);
      if (result.exitCode == 0) {
        mmdcInstalled = true;
      }
    } catch (e) {
      // no-op
    }
  }

  if (!mmdcInstalled) {
    logger.info('Unable to install mmdc.  Aborting!');
    exit(1);
  }
}
