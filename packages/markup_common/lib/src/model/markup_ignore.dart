import 'package:markup_common/markup_common.dart';

/// A `markup:ignore` section.  Any directives in the [contents] within this
/// section will not be processed by markup.
class MarkupIgnore(
  super.contents, {
  required super.end,
  required super.start,
  super.type = 'ignore',
}) extends MarkupBlock {}
