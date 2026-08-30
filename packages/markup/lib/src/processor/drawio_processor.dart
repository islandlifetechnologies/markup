import 'dart:io';

import 'package:json_annotation/json_annotation.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;

import '../../markup.dart';

part 'drawio_processor.g.dart';

typedef DrawIoRunner = File Function({
  required String currentDirectory,
  required File file,
  required int index,
  required Logger logger,
  required DrawIoMode mode,
  required MarkupSection section,
  required int? width,
});

class DrawIoProcessor(
  super.section, {
  super.type = kType,
  @visibleForTesting final DrawIoRunner _runner = _defaultDrawIoRunner,
}) extends MarkupProcessor {
  this {
    _params = _Params.fromJson((section as MarkupDirective).params);
  }

  static const kType = 'drawio';

  late final _Params _params;

  static File _defaultDrawIoRunner({
    required String currentDirectory,
    required File file,
    required int index,
    required Logger logger,
    required DrawIoMode mode,
    required MarkupSection section,
    required int? width,
  }) {
    final relPath = p.relative(file.absolute.path, from: currentDirectory);
    final outFile = '${relPath.replaceAll('.drawio', '')}-$index.${mode.name}';

    final args = [
      'run',
      '-w',
      '/data',
      '-v',
      '$currentDirectory:/data',
      'rlespinasse/drawio-desktop-headless',
      '-x',
      if (width != null) ...['--width', '$width'],
      '-p',
      index.toString(),
      '-o',
      outFile,
      '-f',
      mode.name,
      relPath,
    ];

    final dockerExe = Platform.environment['DOCKER_EXE'] ?? 'docker';
    logger.fine('$dockerExe ${args.join(' ')}');
    final process = Process.runSync(dockerExe, args);

    for (final (name, io) in [
      ('stdio', process.stdout?.toString()),
      ('stderr', process.stderr?.toString()),
    ]) {
      if (io != null && io.isNotEmpty) {
        logger.finest('''
$name:
${io.splitMapJoin('\n', onNonMatch: (s) => '  $s')}
''');
      }
    }

    if (process.exitCode != 0) {
      throw MarkupException.fromSection(section, '''
Error exporting drawio from [${file.path}].
Exit code: ${process.exitCode}.
''');
    }

    return File(outFile);
  }

  @override
  MarkupOutput process(MarkdownDocument doc) {
    final dioFile = getEntity<File>(doc, _params.file);

    if (!dioFile.existsSync()) {
      throw MarkupException.fromSection(
        section,
        'Unable to locate DrawIO file: ${dioFile.path}',
      );
    }

    final outFile = _runner(
      currentDirectory: Directory('.').absolute.path,
      file: dioFile,
      index: _params.index,
      logger: logger,
      mode: _params.mode,
      section: section,
      width: _params.width,
    );

    final docPath = doc.outPath;
    final outPath = p.relative(outFile.absolute.path, from: docPath);

    final label = _params.label ?? outPath;

    return MarkupOutput.fromSection('![$label]($outPath)', section: section);
  }
}

@JsonSerializable(createToJson: false)
class _Params({
  required final String file,
  final String? label,
  final int index = 1,
  final DrawIoMode mode = DrawIoMode.svg,
  final int? width,
}) {
  factory fromJson(Map<String, dynamic> json) => _$ParamsFromJson(json);
}

enum DrawIoMode { png, svg }
