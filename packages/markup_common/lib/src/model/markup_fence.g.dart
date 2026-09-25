// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'markup_fence.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MarkupFence _$MarkupFenceFromJson(Map<String, dynamic> json) => MarkupFence(
  json['content'] as String,
  end: (json['end'] as num).toInt(),
  sectionType: json['sectionType'] as String? ?? _kSectionType,
  start: (json['start'] as num).toInt(),
);

Map<String, dynamic> _$MarkupFenceToJson(MarkupFence instance) =>
    <String, dynamic>{
      'content': instance.content,
      'end': instance.end,
      'sectionType': instance.sectionType,
      'start': instance.start,
    };
