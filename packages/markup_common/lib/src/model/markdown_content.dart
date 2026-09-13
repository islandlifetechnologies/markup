import 'package:markup_common/markup_common.dart';

part 'markdown_content.g.dart';

const _kSectionType = 'MarkdownContent';

/// A section of regular markdown content.
@JsonSerializable()
class MarkdownContent(
  super.content, {
  required super.end,
  super.sectionType = _kSectionType,
  required super.start,
}) extends MarkdownSection {
  factory fromJson(Map<String, dynamic> json) =>
      _$MarkdownContentFromJson(json);

  static const kSectionType = _kSectionType;

  @override
  Map<String, dynamic> toJson() => _$MarkdownContentToJson(this);
}
