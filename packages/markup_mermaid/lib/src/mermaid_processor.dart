import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:markup_common/markup_common.dart';
import 'package:path/path.dart' as p;

part 'mermaid_processor.g.dart';

typedef MermaidProcessRunner = Future<String> Function({
  required List<String> args,
  required String diagramContent,
  required MarkdownDocument doc,
  required MarkupFence fence,
  required Logger logger,
  required File outFile,
  required MarkupRegistry registry,
  required String? title,
});

class MermaidProcessor(
  super.section, {
  final MermaidProcessRunner runner = _defaultProcessRunner,
  required super.registry,
  required super.type,
}) extends MarkupProcessor {
  this : assert(section is MarkupFence), fence = section as MarkupFence {
    _params = _Params.fromJson(fence.params);
  }

  static Future<String> _defaultProcessRunner({
    required List<String> args,
    required String diagramContent,
    required MarkdownDocument doc,
    required MarkupFence fence,
    required Logger logger,
    required File outFile,
    required MarkupRegistry registry,
    required String? title,
  }) async {
    try {
      logger.info('Preparing to run: mmdc ${args.join(' ')}');
      final process = await Process.start('mmdc', args);

      logger.info('Sending diagram content.');
      logger.finest(diagramContent);
      process.stdin.write(diagramContent);
      await process.stdin.flush();
      await process.stdin.close();

      logger.info('Waiting for process result.');
      final out = await utf8.decodeStream(process.stdout);
      final err = await utf8.decodeStream(process.stderr);

      final exitCode = await process.exitCode;
      if (exitCode != 0) {
        for (final (name, io) in [('stdio', out), ('stderr', err)]) {
          logger.finest('$name\n$io');
        }

        exit(exitCode);
      }

      if (logger.isLoggable(Level.FINEST)) {
        for (final (name, io) in [('stdio', out), ('stderr', err)]) {
          logger.finest('$name\n$io');
        }
      }

      final cd = registry.fs.directory(doc.path);
      final path = p.relative(outFile.absolute.path, from: cd.absolute.path);
      final content = '![${title ?? path}]($path)';
      return content;
    } catch (e, stack) {
      logger.severe('Error running plugin', e, stack);
      await Future.delayed(const Duration(seconds: 1));
      exit(1);
    }
  }

  final MarkupFence fence;
  late final _Params _params;

  @override
  FutureOr<MarkupOutput> process(MarkdownDocument doc) async {
    final lines = section.content.trim().split('\n');

    // Remove the first and last line as those are the fence lines.
    final diagramContent = lines.sublist(1, lines.length - 1).join('\n');
    final hash = sha256.convert(utf8.encode(diagramContent)).toString();

    final outType =
        _params.outputFormat ??
        (_params.output == null ? null : p.extension(_params.output!)) ??
        'svg';
    final outFile = getEntity<File>(
      doc,
      (_params.output ?? p.join(doc.outPath, 'mermaid-$hash.$outType')),
    );

    if (!outFile.parent.existsSync()) {
      outFile.parent.createSync(recursive: true);
    }
    final args = [
      if (_params.backgroundColor != null) ...[
        '--backgroundColor',
        _params.backgroundColor,
      ],
      if (_params.height != null) ...['--height', _params.height],
      '--input',
      '-',
      if (_params.scale != null) ...['--scale', _params.scale],
      if (_params.theme != null) ...['--theme', _params.theme],
      if (_params.width != null) ...['--width', _params.width],
      '--outputFormat',
      outType,
      '--output',
      outFile.absolute.path,
    ].map((arg) => arg.toString()).toList();

    final content = await runner(
      args: args,
      diagramContent: diagramContent,
      doc: doc,
      fence: fence,
      logger: logger,
      outFile: outFile,
      registry: registry,
      title: _params.title,
    );

    logger.finer('Output:\n$content');
    return MarkupOutput.fromSection(content, section: section);
  }
}

@JsonSerializable()
class _Params(
  final String? backgroundColor,
  @JsonKey(fromJson: JsonClass.maybeParseInt) final int? height,
  final String? output,
  final String? outputFormat,
  @JsonKey(fromJson: JsonClass.maybeParseInt) final int? scale,
  final String? theme,
  final String? title,
  @JsonKey(fromJson: JsonClass.maybeParseInt) final int? width,
) {
  factory fromJson(Map<String, dynamic> json) => _$ParamsFromJson(json);
}
