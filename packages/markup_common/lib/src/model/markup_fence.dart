import 'package:markup_common/markup_common.dart';

class MarkupFence(super.content, {required super.end, required super.start})
    extends MarkupSection {
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

  static final fenceRegEx = RegExp(
    r'^(?<indent>\s*)(?<fence>```+)(?<type>\S*)?\s*(?<params>.*)',
  );

  late final int _indent;
  late final Map<String, dynamic> _params;
  late final String _type;

  int get indent => _indent;

  Map<String, dynamic> get params => _params;

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
