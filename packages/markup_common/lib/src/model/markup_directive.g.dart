// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'markup_directive.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MarkupDirective _$MarkupDirectiveFromJson(Map<String, dynamic> json) =>
    MarkupDirective(
      json['content'] as String,
      end: (json['end'] as num).toInt(),
      params: json['params'] as Map<String, dynamic>?,
      sectionType: json['sectionType'] as String? ?? _kSectionType,
      start: (json['start'] as num).toInt(),
    )..type = json['type'] as String;

Map<String, dynamic> _$MarkupDirectiveToJson(MarkupDirective instance) =>
    <String, dynamic>{
      'content': instance.content,
      'end': instance.end,
      'sectionType': instance.sectionType,
      'start': instance.start,
      'type': instance.type,
      'params': instance.params,
    };

MarkupDirectiveOutput _$MarkupDirectiveOutputFromJson(
  Map<String, dynamic> json,
) => MarkupDirectiveOutput(
  fence: json['fence'] as String?,
  fenceType: json['fence-type'] as String?,
);

Map<String, dynamic> _$MarkupDirectiveOutputToJson(
  MarkupDirectiveOutput instance,
) => <String, dynamic>{
  'fence': instance.fence,
  'fence-type': instance.fenceType,
};
