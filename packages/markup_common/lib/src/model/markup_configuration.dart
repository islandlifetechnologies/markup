import 'package:file/local.dart';
import 'package:markup_common/markup_common.dart';
import 'package:meta/meta.dart';

part 'markup_configuration.g.dart';

@JsonSerializable()
class MarkupConfiguration({
  /// Perform a dry run, print all the logs, but do not write any Markdown
  /// files.
  @JsonKey(name: 'dry-run') final bool dryRun = false,

  /// Display help message.
  final bool help = false,

  /// The search glob to find the file or files to modify.
  final String include = '**/*.md',

  /// Log level to use.
  final String log = 'INFO',

  /// If set, all results will be written to this path and it's sub paths.
  final String? output,

  /// The plugins to use.
  final Map<String, MarkupPluginData>? plugins,

  /// Display version information.
  final bool version = false,
}) {
  factory fromJson(Map<String, dynamic> json) =>
      _$MarkupConfigurationFromJson(json);

  static (MarkupConfiguration, ArgParser) create(
    List<String> args, {
    @visibleForTesting FileSystem? fs,
  }) {
    fs ??= LocalFileSystem();
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
      ..addFlag('help', help: 'Display this message.', negatable: false)
      ..addFlag(
        'version',
        help: 'Display version information.',
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
      final file = fs.file(configPath);
      if (!file.existsSync()) {
        throw Exception(
          'Unable to locate configuration file: ${file.absolute.path}',
        );
      }
      final c = yaon.parse(file.readAsStringSync()) as Map<String, dynamic>;

      for (final entry in c.entries) {
        if (!config.containsKey(entry.key)) {
          config[entry.key] = entry.value;
        }
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
  @JsonKey(name: 'ignore-exit-code') final bool ignoreExitCode = false,
  @JsonKey(name: 'post-processor') final bool postProcessor = false,
  @JsonKey(name: 'replace') final bool replace = false,
  @JsonKey(name: 'timeout', fromJson: JsonClass.parseDurationFromSeconds)
  final Duration timeout = const Duration(minutes: 1),
}) {
  factory fromJson(Map<String, dynamic> json) =>
      _$MarkupPluginDataFromJson(json);

  Map<String, dynamic> toJson() => _$MarkupPluginDataToJson(this);
}
