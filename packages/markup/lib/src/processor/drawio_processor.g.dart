// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drawio_processor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Params _$ParamsFromJson(Map<String, dynamic> json) => _Params(
  file: json['file'] as String,
  label: json['label'] as String?,
  index: (json['index'] as num?)?.toInt() ?? 1,
  mode:
      $enumDecodeNullable(_$DrawIoModeEnumMap, json['mode']) ?? DrawIoMode.svg,
  width: (json['width'] as num?)?.toInt(),
);

const _$DrawIoModeEnumMap = {DrawIoMode.png: 'png', DrawIoMode.svg: 'svg'};
