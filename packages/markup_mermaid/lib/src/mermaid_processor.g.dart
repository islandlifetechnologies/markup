// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mermaid_processor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Params _$ParamsFromJson(Map<String, dynamic> json) => _Params(
  json['backgroundColor'] as String?,
  json['output'] as String?,
  json['outputFormat'] as String?,
  JsonClass.maybeParseInt(json['scale']),
  JsonClass.maybeParseInt(json['size']),
  json['theme'] as String?,
  json['title'] as String?,
);

Map<String, dynamic> _$ParamsToJson(_Params instance) => <String, dynamic>{
  'backgroundColor': instance.backgroundColor,
  'output': instance.output,
  'outputFormat': instance.outputFormat,
  'scale': instance.scale,
  'size': instance.size,
  'theme': instance.theme,
  'title': instance.title,
};
