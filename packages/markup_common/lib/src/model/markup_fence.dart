import 'package:markup_common/markup_common.dart';

part 'markup_fence.g.dart';

const _kSectionType = 'MarkupFence';

@JsonSerializable()
class MarkupFence(
  super.content, {
  required super.end,
  super.sectionType = _kSectionType,
  required super.start,
}) extends MarkupSection {
  this {
    final match = fenceRegEx.firstMatch(content);
    if (match == null) {
      throw MarkupException.fromSection(this, 'Invalid fence: $content');
    }
    _indent = (match.namedGroup('indent') ?? '').length;

    final pGroup = match.namedGroup('params')?.toString().trim();
    final params = yaon.tryParse(pGroup);
    _params = params is Map<String, dynamic> ? params : const {};

    _type = match.namedGroup('type') ?? '';
  }

  factory fromJson(Map<String, dynamic> json) => _$MarkupFenceFromJson(json);

  static const kSectionType = _kSectionType;
  static final fenceRegEx = RegExp(
    r'^(?<indent>\s*)(?<fence>```+)(?<type>\S*)?\s*(?<params>.*)',
  );

  late final int _indent;
  late final Map<String, dynamic> _params;
  late final String _type;

  int get indent => _indent;

  @override
  Map<String, dynamic> get params => _params;

  @override
  Map<String, dynamic> toJson() => _$MarkupFenceToJson(this);

  @override
  String get type => _type;

  String get withoutIndent => content
      .split('\n')
      .map((line) {
        if (line.length < _indent) {
          return '';
        }
        return line.substring(_indent);
      })
      .join('\n');
}
