// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'markup_ignore.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MarkupIgnore _$MarkupIgnoreFromJson(Map<String, dynamic> json) => MarkupIgnore(
  json['content'] as String,
  end: (json['end'] as num).toInt(),
  sectionType: json['sectionType'] as String? ?? _kSectionType,
  start: (json['start'] as num).toInt(),
  type: json['type'] as String? ?? 'ignore',
);

Map<String, dynamic> _$MarkupIgnoreToJson(MarkupIgnore instance) =>
    <String, dynamic>{
      'content': instance.content,
      'end': instance.end,
      'sectionType': instance.sectionType,
      'start': instance.start,
      'type': instance.type,
    };
