import 'package:markup/markup.dart';

part 'file_processor.g.dart';

class FileProcessor(
  super.section, {
  required super.registry,
  super.type = kType,
}) extends MarkupProcessor {
  this {
    final directive = section as MarkupDirective;
    _output = directive.output;
    _params = _Params.fromJson(directive.params);
  }
  static const kType = 'file';

  late final MarkupDirectiveOutput _output;
  late final _Params _params;

  @override
  MarkupOutput process(MarkdownDocument doc) {
    final file = getEntity<File>(doc, _params.file);

    if (!file.existsSync()) {
      throw MarkupException.fromSection(
        section,
        'Unable to read file: ${file.absolute.path}',
      );
    }

    return MarkupOutput.fromSection(
      file.readAsStringSync(),
      output: _output,
      section: section,
    );
  }
}

@JsonSerializable()
class _Params({required final String file}) {
  factory fromJson(Map<String, dynamic> json) => _$ParamsFromJson(json);
}
