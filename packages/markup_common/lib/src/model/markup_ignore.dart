import 'package:markup_common/markup_common.dart';

/// A `markup:ignore` section.  Any directives in the [content] within this
/// section will not be processed by markup.
class MarkupIgnore(
  super.content, {
  required super.end,
  required super.start,
  super.type = 'ignore',
}) extends MarkupBlock {}
