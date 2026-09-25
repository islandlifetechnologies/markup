// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'markdown_content.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MarkdownContent _$MarkdownContentFromJson(Map<String, dynamic> json) =>
    MarkdownContent(
      json['content'] as String,
      end: (json['end'] as num).toInt(),
      sectionType: json['sectionType'] as String? ?? _kSectionType,
      start: (json['start'] as num).toInt(),
    );

Map<String, dynamic> _$MarkdownContentToJson(MarkdownContent instance) =>
    <String, dynamic>{
      'content': instance.content,
      'end': instance.end,
      'sectionType': instance.sectionType,
      'start': instance.start,
    };
