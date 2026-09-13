import 'package:markup_common/markup_common.dart';

part 'markup_plugin_input.g.dart';

@JsonSerializable(explicitToJson: true)
class MarkupPluginInput({
  required final MarkdownDocument doc,
  required final MarkupSection section,
}) {
  factory fromJson(Map<String, dynamic> json) =>
      _$MarkupPluginInputFromJson(json);

  Map<String, dynamic> toJson() => _$MarkupPluginInputToJson(this);
}
