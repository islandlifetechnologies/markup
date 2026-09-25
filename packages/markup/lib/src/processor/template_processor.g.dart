// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'template_processor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Params _$ParamsFromJson(Map<String, dynamic> json) => _Params(
  context: json['context'] as Map<String, dynamic>? ?? const {},
  file: json['file'] as String?,
  syntax:
      $enumDecodeNullable(_$_TemplateSyntaxEnumMap, json['syntax']) ??
      _TemplateSyntax.standard,
  template: json['template'] as String?,
);

Map<String, dynamic> _$ParamsToJson(_Params instance) => <String, dynamic>{
  'context': instance.context,
  'file': instance.file,
  'syntax': _$_TemplateSyntaxEnumMap[instance.syntax]!,
  'template': instance.template,
};

const _$_TemplateSyntaxEnumMap = {
  _TemplateSyntax.hash: 'hash',
  _TemplateSyntax.mustache: 'mustache',
  _TemplateSyntax.standard: 'standard',
  _TemplateSyntax.pipe: 'pipe',
};
