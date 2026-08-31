import 'package:markup_common/markup_common.dart';

class MarkupBlock(
  super.contents, {
  required super.end,
  required super.start,
  required final String _type,
}) extends MarkupSection {
  @override
  String get type => _type;
}
