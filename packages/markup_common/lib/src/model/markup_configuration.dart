import 'dart:io';

import 'package:markup_common/markup_common.dart';

part 'markup_configuration.g.dart';

@JsonSerializable()
class MarkupConfiguration({
  @JsonKey(name: 'dry-run') final bool dryRun = false,
  final bool help = false,
  final String include = '**/*.md',
  final String log = 'INFO',
  final String? output,
  final Map<String, MarkupPluginData>? plugins,
  final bool version = false,
}) {
  factory fromJson(Map<String, dynamic> json) =>
      _$MarkupConfigurationFromJson(json);

  static (MarkupConfiguration, ArgParser) create(List<String> args) {
    final parser = ArgParser()
      ..addOption(
        'config',
        abbr: 'c',
        help: 'Configuration file for markup to use.',
      )
      ..addOption(
        'include',
        abbr: 'i',
        help: 'The search glob to find the file or files to modify.',
      )
      ..addOption(
        'log',
        abbr: 'l',
        allowed: Level.LEVELS.map((l) => l.name),
        help: 'Log level to use.',
      )
      ..addOption(
        'output',
        abbr: 'o',
        help: "If set, all results will be written to this path and it's sub paths.",
      )
      ..addFlag(
        'dry-run',
        help: 'Perform a dry run, print all the logs, but do not write any Markdown files.',
        negatable: false,
      )
      ..addFlag('help', help: 'Display this message', negatable: false)
      ..addFlag(
        'version',
        help: 'Display version information',
        negatable: false,
      );

    final parsed = parser.parse(args);

    final configPath = parsed['config'];
    final config = <String, dynamic>{
      'dry-run': parsed['dry-run'],
      'help': parsed['help'],
      'include': parsed['include'],
      'log': parsed['log'],
      'output': parsed['output'],
      'version': parsed['version'],
    }..removeWhere((key, value) => value == null);

    if (configPath != null) {
      final file = File(configPath);
      if (!file.existsSync()) {
        throw Exception(
          'Unable to locate configuration file: ${file.absolute.path}',
        );
      }
      final c = yaon.parse(file.readAsStringSync()) as Map<String, dynamic>;

      for (final entry in c.entries) {
        config.putIfAbsent(entry.key, entry.value);
      }
    }

    return (MarkupConfiguration.fromJson(config), parser);
  }

  Map<String, dynamic> toJson() => _$MarkupConfigurationToJson(this);
}

@JsonSerializable()
class MarkupPluginData({
  final List<String> args = const [],
  required final String command,
  @JsonKey(name: 'post-processor') final bool postProcessor = false,
  @JsonKey(name: 'working-direction') final String? workingDirectory,
}) {
  factory fromJson(Map<String, dynamic> json) =>
      _$MarkupPluginDataFromJson(json);

  Map<String, dynamic> toJson() => _$MarkupPluginDataToJson(this);
}
