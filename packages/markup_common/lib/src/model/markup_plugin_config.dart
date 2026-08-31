import 'package:markup_common/markup_common.dart';

part 'markup_plugin_config.g.dart';

@JsonSerializable()
class MarkupPluginConfig(final Map<String, dynamic> plugins) {
  factory fromJson(Map<String, dynamic> json) =>
      _$MarkupPluginConfigFromJson(json);

  Map<String, dynamic> toJson() => _$MarkupPluginConfigToJson(this);
}
