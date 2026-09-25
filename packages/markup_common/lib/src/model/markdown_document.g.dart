// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'markdown_document.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MarkdownDocument _$MarkdownDocumentFromJson(Map<String, dynamic> json) =>
    MarkdownDocument(
      (json['sections'] as List<dynamic>)
          .map((e) => MarkdownSection.fromJson(e as Map<String, dynamic>))
          .toList(),
      outPath: json['outPath'] as String,
      path: json['path'] as String,
    );

Map<String, dynamic> _$MarkdownDocumentToJson(MarkdownDocument instance) =>
    <String, dynamic>{
      'outPath': instance.outPath,
      'path': instance.path,
      'sections': instance.sections.map((e) => e.toJson()).toList(),
    };
