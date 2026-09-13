import 'package:markup_common/markup_common.dart';

part 'markup_directive.g.dart';

const _kSectionType = 'MarkupDirective';

/// A directive for markup for processing.  This is only usable for single tag
/// syntax directives.
@JsonSerializable()
class MarkupDirective(
  super.content, {
  required super.end,
  Map<String, dynamic>? params,
  super.sectionType = _kSectionType,
  required super.start,
}) extends MarkupSection {
  this {
    if (params == null) {
      final regEx = RegExp(
        r'<!--\s*markup:(?<key>[^\s]*)(?<params>.*)?\s*/-->',
        dotAll: true,
      );
      final match = regEx.firstMatch(content)!;

      final key = match.namedGroup('key')!.trim();
      final paramStr = match.namedGroup('params')?.trim();

      type = key;
      _params = yaon.parse(paramStr) ?? const <String, dynamic>{};
    } else {
      _params = params;
    }
  }

  factory fromJson(Map<String, dynamic> json) =>
      _$MarkupDirectiveFromJson(json);

  static const kSectionType = _kSectionType;

  late final Map<String, dynamic> _params;

  @override
  late final String type;

  @override
  Map<String, dynamic> get params => _params;

  @override
  Map<String, dynamic> toJson() => _$MarkupDirectiveToJson(this);
}
