import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:markup_common/markup_common.dart';
import 'package:path/path.dart' as p;

part 'mermaid_processor.g.dart';

class MermaidProcessor extends MarkupProcessor {
  new(super.section, {required super.type})
    : assert(section is MarkupFence),
      fence = section as MarkupFence {
    _params = _MermaidProcessorParams.fromJson(fence.params);
  }

  final MarkupFence fence;
  late final _MermaidProcessorParams _params;

  @override
  FutureOr<MarkupOutput> process(MarkdownDocument doc) async {
    final lines = section.content.split('\n');

    // Remove the first and last line as those are the fence lines.
    final diagramContent = lines.sublist(1, lines.length - 1).join('\n');

    final hash = sha256.convert(utf8.encode(diagramContent)).toString();

    final outType =
        _params.outputFormat ??
        (_params.output == null ? null : p.extension(_params.output!)) ??
        'svg';
    final outFile = getEntity<File>(
      doc,
      (_params.output ?? 'generated/mermaid-$hash.$outType'),
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
      if (_params.scale != null) ...['--scale', _params.scale],
      if (_params.theme != null) ...['--theme', _params.theme],
      if (_params.width != null) ...['--width', _params.width],
      '--outputFormat',
      outType,
      '--output',
      outFile.absolute.path,
    ].map((arg) => arg.toString()).toList();

    logger.info('Preparing to run: mmdc ${args.join(' ')}');
    final process = await Process.start('mmdc', args);

    process.stdin.write(diagramContent);

    final exitCode = await process.exitCode;
    if (exitCode != 0) {
      exit(exitCode);
    }

    final cd = Directory(doc.path);
    final path = p.relative(outFile.absolute.path, from: cd.absolute.path);
    final content = '![$path]($path)';
    return MarkupOutput.fromSection(content, section: section);
  }
}

@JsonSerializable(createToJson: false)
class _MermaidProcessorParams(
  final String? backgroundColor,
  @JsonKey(fromJson: JsonClass.maybeParseInt) final int? height,
  final String? output,
  final String? outputFormat,
  @JsonKey(fromJson: JsonClass.maybeParseInt) final int? scale,
  final String? theme,
  @JsonKey(fromJson: JsonClass.maybeParseInt) final int? width,
) {
  factory fromJson(Map<String, dynamic> json) =>
      _$MermaidProcessorParamsFromJson(json);
}
