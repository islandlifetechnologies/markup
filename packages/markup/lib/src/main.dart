// ignore_for_file: avoid_print

import 'dart:io';

import 'package:glob/glob.dart';
import 'package:glob/list_local_fs.dart';
import 'package:markup/markup.dart';
import 'package:markup/src/constant/pubspec.dart';
import 'package:markup/src/processor/plugin_processor.dart';
import 'package:path/path.dart' as p;

Future<void> main(List<String> args, {bool allowExit = true}) async {
  final registry = DefaultMarkupRegistry();
  final logger = initLogging(name: 'main');
  final cd = registry.fs.directory('.');

  final (config, parser) = MarkupConfiguration.create(args);

  if (config.help || config.version) {
    print('markup ${kPubspec.version}');
    if (config.help) {
      print('');
      print(parser.usage);
    }
    if (allowExit) {
      exit(0);
    }
    throw UnsupportedError('Should have exited');
  }

  final level =
      Level.LEVELS.where((l) => l.name == config.log).firstOrNull ?? Level.INFO;
  Logger.root.level = level;

  logger.config(config.toString());

  final output = config.output;
  Directory? outDir;
  if (output != null) {
    outDir = registry.fs.directory(output);
    if (!config.dryRun) {
      if (outDir.existsSync()) {
        outDir.deleteSync(recursive: true);
      }
      outDir.createSync(recursive: true);
    }
  }

  final include = Glob(config.include, recursive: true);

  for (final file in include.listSync().whereType<File>().where((f) {
    // Ignore all hidden files
    final parts = f.absolute.path
        .split('/')
        .where((p) => p != '.' && p != '..');
    return parts.where((p) => p.startsWith('.')).isEmpty;
  })) {
    for (final entry
        in (config.plugins ?? const <String, MarkupPluginData>{}).entries) {
      final plugin = entry.value;
      logger.config('Registering plugin: ${entry.key}');
      registry.registerBuilder(entry.key, (section, {required registry}) {
        return PluginProcessor(
          section,
          plugin: plugin,
          registry: registry,
          type: entry.key,
        );
      });
    }
    logger.info('Scanning: ${file.path}');
    final scanner = MarkdownScanner.fromFile(
      file,
      output: outDir == null
          ? null
          : registry.fs.directory(
              p.join(
                outDir.absolute.path,
                p.relative(
                  p.dirname(file.absolute.path),
                  from: cd.absolute.path,
                ),
              ),
            ),
    );
    final doc = scanner.scan(registry: registry);
    if (logger.isLoggable(Level.FINEST)) {
      logger.finest('Document Sections:');
      for (final section in doc.sections) {
        logger.finest('  • ${section.runtimeType}: ${section.sectionType}');
      }
    }
    final result = await doc.process(registry);

    final outFile = registry.fs.file(
      p.join(doc.outPath, p.basename(file.path)),
    );
    logger.info('Writing: ${outFile.path}');
    if (!config.dryRun) {
      if (!outFile.existsSync()) {
        outFile.createSync(recursive: true);
      }
      outFile.writeAsStringSync(result.toString());
    }
  }

  logger.info('Complete.');

  if (allowExit) {
    exit(0);
  }
}
