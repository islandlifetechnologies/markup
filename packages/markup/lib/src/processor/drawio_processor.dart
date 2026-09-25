import 'dart:io' show Platform, Process;

import 'package:markup/markup.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;

part 'drawio_processor.g.dart';

typedef DrawIoRunner = File Function({
  required String currentDirectory,
  required File file,
  required FileSystem fs,
  required int index,
  required Logger logger,
  required DrawIoMode mode,
  required MarkupSection section,
  required int? width,
});

class DrawIoProcessor(
  super.section, {
  required super.registry,
  super.type = kType,
  @visibleForTesting final DrawIoRunner _runner = _defaultDrawIoRunner,
}) extends MarkupProcessor {
  this {
    final directive = section as MarkupDirective;
    _output = directive.output;
    _params = _Params.fromJson(directive.params);
  }

  static const kType = 'drawio';

  late final MarkupDirectiveOutput _output;
  late final _Params _params;

  static File _defaultDrawIoRunner({
    required String currentDirectory,
    required File file,
    required FileSystem fs,
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

    if (process.exitCode != 0) {
      for (final (name, io) in [
        ('stdio', process.stdout?.toString()),
        ('stderr', process.stderr?.toString()),
      ]) {
        if (io != null && io.isNotEmpty) {
          logger.severe('''
$name:
${io.splitMapJoin('\n', onNonMatch: (s) => '  $s')}
''');
        }
      }
      throw MarkupException.fromSection(section, '''
Error exporting drawio from [${file.path}].
Exit code: ${process.exitCode}.
''');
    }

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
    return fs.file(outFile);
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
      currentDirectory: registry.fs.directory('.').absolute.path,
      file: dioFile,
      fs: registry.fs,
      index: _params.index,
      logger: logger,
      mode: _params.mode,
      section: section,
      width: _params.width,
    );

    final docPath = doc.outPath;
    final outPath = p.relative(outFile.absolute.path, from: docPath);

    final label = _params.label ?? outPath;

    return MarkupOutput.fromSection(
      '![$label]($outPath)',
      output: _output,
      section: section,
    );
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
