import 'dart:io';

import 'package:json_annotation/json_annotation.dart';

import '../../markup.dart';

part 'file_processor.g.dart';

class FileProcessor(super.section, {super.type = kType})
    extends MarkupProcessor {
  this {
    _params = _Params.fromJson((section as MarkupDirective).params);
  }
  static const kType = 'file';

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

    return MarkupOutput.fromSection(file.readAsStringSync(), section: section);
  }
}

@JsonSerializable()
class _Params({required final String file}) {
  factory fromJson(Map<String, dynamic> json) => _$ParamsFromJson(json);
}
