import 'package:markup/markup.dart';
import 'package:yaon/yaon.dart';

class MarkupDirective(
  super.contents, {
  required super.end,
  required super.start,
}) extends MarkupSection {
  this {
    final regEx = RegExp(
      r'<!--\s*markup:(?<key>[^\s]*)(?<params>.*)?\s*/-->',
      dotAll: true,
    );
    // final regEx = RegExp(r'<!--\s*markup:(?<key>[^\s]*)', multiLine: true);

    final match = regEx.firstMatch(contents)!;

    final key = match.namedGroup('key')!.trim();
    final paramStr = match.namedGroup('params')?.trim();

    type = key;
    params = yaon.parse(paramStr) ?? const <String, dynamic>{};
  }

  late final Map<String, dynamic> params;
  @override
  late final String type;
}
