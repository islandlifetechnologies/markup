import 'package:markup/markup.dart';

class MarkupIgnore(super.contents, {required super.end, required super.start})
    extends MarkupSection {
  @override
  String get type => 'ignore';
}
