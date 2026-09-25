// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'process_processor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Params _$ParamsFromJson(Map<String, dynamic> json) => _Params(
  args:
      (json['args'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  command: json['command'] as String,
  ignoreExitCode: json['ignore-exit-code'] as bool? ?? false,
  timeout: json['timeout'] == null
      ? const Duration(minutes: 1)
      : JsonClass.parseDurationFromSeconds(json['timeout']),
  workingDirectory: json['working-directory'] as String? ?? '.',
);

Map<String, dynamic> _$ParamsToJson(_Params instance) => <String, dynamic>{
  'args': instance.args,
  'command': instance.command,
  'ignore-exit-code': instance.ignoreExitCode,
  'timeout': instance.timeout.inMicroseconds,
  'working-directory': instance.workingDirectory,
};
