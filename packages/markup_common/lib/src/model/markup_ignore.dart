import 'package:markup_common/markup_common.dart';

part 'markup_ignore.g.dart';

const _kSectionType = 'MarkupIgnore';

/// A `markup:ignore` section.  Any directives in the [content] within this
/// section will not be processed by markup.
@JsonSerializable()
class MarkupIgnore(
  super.content, {
  required super.end,
  super.sectionType = _kSectionType,
  required super.start,
  super.type = 'ignore',
}) extends MarkupBlock {
  factory fromJson(Map<String, dynamic> json) => _$MarkupIgnoreFromJson(json);

  static const kSectionType = _kSectionType;

  @override
  Map<String, dynamic> toJson() => _$MarkupIgnoreToJson(this);
}
