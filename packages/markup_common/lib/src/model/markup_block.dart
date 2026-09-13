import 'package:markup_common/markup_common.dart';

abstract class MarkupBlock(
  super.content, {
  required super.end,
  required super.sectionType,
  required super.start,
  required final String _type,
}) extends MarkupSection {
  factory fromJson(Map<String, dynamic> json) => switch (json['sectionType']) {
    MarkupIgnore.kSectionType => MarkupIgnore.fromJson(json),
    MarkupOutput.kSectionType => MarkupOutput.fromJson(json),

    // Defaults to the safest option to use when otherwise unknown
    _ => throw UnsupportedError('Unknown section type: ${json['sectionType']}'),
  };

  @override
  Map<String, dynamic> get params => const {};

  @override
  String get type => _type;
}
