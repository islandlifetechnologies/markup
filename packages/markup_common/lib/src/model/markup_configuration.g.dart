// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'markup_configuration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MarkupConfiguration _$MarkupConfigurationFromJson(Map<String, dynamic> json) =>
    MarkupConfiguration(
      dryRun: json['dry-run'] as bool? ?? false,
      help: json['help'] as bool? ?? false,
      include: json['include'] as String? ?? '**/*.md',
      log: json['log'] as String? ?? 'INFO',
      output: json['output'] as String?,
      plugins: (json['plugins'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry(k, MarkupPluginData.fromJson(e as Map<String, dynamic>)),
      ),
      version: json['version'] as bool? ?? false,
    );

Map<String, dynamic> _$MarkupConfigurationToJson(
  MarkupConfiguration instance,
) => <String, dynamic>{
  'dry-run': instance.dryRun,
  'help': instance.help,
  'include': instance.include,
  'log': instance.log,
  'output': instance.output,
  'plugins': instance.plugins,
  'version': instance.version,
};

MarkupPluginData _$MarkupPluginDataFromJson(Map<String, dynamic> json) =>
    MarkupPluginData(
      args:
          (json['args'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const [],
      command: json['command'] as String,
      ignoreExitCode: json['ignore-exit-code'] as bool? ?? false,
      postProcessor: json['post-processor'] as bool? ?? false,
      replace: json['replace'] as bool? ?? false,
      timeout: json['timeout'] == null
          ? const Duration(minutes: 1)
          : JsonClass.parseDurationFromSeconds(json['timeout']),
    );

Map<String, dynamic> _$MarkupPluginDataToJson(MarkupPluginData instance) =>
    <String, dynamic>{
      'args': instance.args,
      'command': instance.command,
      'ignore-exit-code': instance.ignoreExitCode,
      'post-processor': instance.postProcessor,
      'replace': instance.replace,
      'timeout': instance.timeout.inMicroseconds,
    };
