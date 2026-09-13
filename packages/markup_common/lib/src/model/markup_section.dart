import 'package:markup_common/markup_common.dart';

/// An abstract section that is known to the markup platform for special
/// handling.
abstract class MarkupSection(
  super.content, {
  required super.end,
  required super.sectionType,
  required super.start,
}) extends MarkdownSection {
  factory fromJson(Map<String, dynamic> json) => switch (json['sectionType']) {
    MarkupDirective.kSectionType => MarkupDirective.fromJson(json),
    MarkupFence.kSectionType => MarkupFence.fromJson(json),
    MarkupIgnore.kSectionType => MarkupIgnore.fromJson(json),
    MarkupOutput.kSectionType => MarkupOutput.fromJson(json),

    // Defaults to the safest option to use when otherwise unknown
    _ => throw UnsupportedError('Unknown section type: ${json['sectionType']}'),
  };

  Map<String, dynamic>? get params;
  String get type;
}
