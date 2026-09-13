// ignore_for_file: avoid_print

import 'dart:io';

import 'package:file/local.dart';
import 'package:markup_common/markup_common.dart';
import 'package:path/path.dart' as p;

class MarkupPluginArgs {
  ArgResults process(
    List<String> args, {
    String? exampleConfig,
    ArgParser? parser,
    String? version,
  }) {
    parser ??= ArgParser();
    parser
      ..addOption(
        'log',
        abbr: 'l',
        allowed: Level.LEVELS.map((l) => l.name),
        help: 'Log level to use',
      )
      ..addOption('log-file', abbr: 'f', help: 'File to write log output to')
      ..addFlag('help', abbr: 'h', help: 'Display help information');

    if (version != null) {
      parser.addFlag(
        'version',
        abbr: 'v',
        help: 'Print the current version of the plugin',
      );
    }

    final parsed = parser.parse(args);

    final outFilePath = parsed['log-file'];
    File? outFile;
    if (outFilePath != null) {
      outFile = LocalFileSystem().file(outFilePath);
      if (outFile.existsSync()) {
        outFile.deleteSync(recursive: true);
      }
      outFile.createSync(recursive: true);
    }

    if (parsed['help'] == true || parsed['version'] == true) {
      if (version != null) {
        print('${p.basename(Platform.executable)} $version');
      } else {
        print(p.basename(Platform.executable));
      }

      if (parsed['help'] == true) {
        print('');
        print('Usage:');
        print(parser.usage);
        if (exampleConfig != null) {
          print('');
          print('Example markup.yaml:');
          print(exampleConfig);
        }
      }
      exit(0);
    }

    final level =
        Level.LEVELS
            .where(
              (l) =>
                  l.name.toLowerCase() ==
                  parsed['log']?.toString().toLowerCase(),
            )
            .firstOrNull ??
        Level.INFO;

    // ignore: close_sinks
    final sink = outFile?.openWrite(mode: FileMode.writeOnlyAppend);
    initLogging(
      name: p.basename(Platform.executable),
      level: level,
      printer: (str) {
        if (sink != null) {
          sink.writeln(str);
        } else {
          stderr.writeln(str);
        }
      },
    );

    return parsed;
  }
}
