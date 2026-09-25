// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'markup_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MarkupOutput _$MarkupOutputFromJson(Map<String, dynamic> json) => MarkupOutput(
  json['content'] as String,
  end: (json['end'] as num).toInt(),
  sectionType: json['sectionType'] as String? ?? _kSectionType,
  start: (json['start'] as num).toInt(),
  type: json['type'] as String? ?? 'output',
);

Map<String, dynamic> _$MarkupOutputToJson(MarkupOutput instance) =>
    <String, dynamic>{
      'content': instance.content,
      'end': instance.end,
      'sectionType': instance.sectionType,
      'start': instance.start,
      'type': instance.type,
    };
