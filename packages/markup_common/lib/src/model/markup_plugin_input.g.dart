// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'markup_plugin_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MarkupPluginInput _$MarkupPluginInputFromJson(Map<String, dynamic> json) =>
    MarkupPluginInput(
      doc: MarkdownDocument.fromJson(json['doc'] as Map<String, dynamic>),
      section: MarkupSection.fromJson(json['section'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MarkupPluginInputToJson(MarkupPluginInput instance) =>
    <String, dynamic>{
      'doc': instance.doc.toJson(),
      'section': instance.section.toJson(),
    };
