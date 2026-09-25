// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mermaid_processor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Params _$ParamsFromJson(Map<String, dynamic> json) => _Params(
  json['backgroundColor'] as String?,
  JsonClass.maybeParseInt(json['height']),
  json['output'] as String?,
  json['outputFormat'] as String?,
  JsonClass.maybeParseInt(json['scale']),
  json['theme'] as String?,
  json['title'] as String?,
  JsonClass.maybeParseInt(json['width']),
);

Map<String, dynamic> _$ParamsToJson(_Params instance) => <String, dynamic>{
  'backgroundColor': instance.backgroundColor,
  'height': instance.height,
  'output': instance.output,
  'outputFormat': instance.outputFormat,
  'scale': instance.scale,
  'theme': instance.theme,
  'title': instance.title,
  'width': instance.width,
};
