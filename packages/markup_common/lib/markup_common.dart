// ignore_for_file: avoid_print

import 'package:logging/logging.dart';

export 'package:args/args.dart';
export 'package:crypto/crypto.dart';
export 'package:file/file.dart';
export 'package:json_annotation/json_annotation.dart';
export 'package:json_class/json_class.dart';
export 'package:logging/logging.dart';
export 'package:template_expressions/template_expressions.dart';
export 'package:yaon/yaon.dart';

export 'src/exception/markup_exception.dart';
export 'src/model/markdown_content.dart';
export 'src/model/markdown_document.dart';
export 'src/model/markdown_section.dart';
export 'src/model/markup_block.dart';
export 'src/model/markup_configuration.dart';
export 'src/model/markup_directive.dart';
export 'src/model/markup_fence.dart';
export 'src/model/markup_ignore.dart';
export 'src/model/markup_output.dart';
export 'src/model/markup_plugin_input.dart';
export 'src/model/markup_section.dart';
export 'src/plugin/markup_plugin_args.dart';
export 'src/plugin/markup_plugin_runner.dart';
export 'src/processor/markup_processor.dart';
export 'src/registry/markup_registry.dart';

Logger initLogging({
  String? name,
  Level level = Level.INFO,
  void Function(String) printer = print,
}) {
  Logger.root.onRecord.listen((record) {
    printer('${{record.time}}: ${record.level}: ${record.message}');

    final (e, stack) = (record.error, record.stackTrace);
    for (final i in [e, stack]) {
      if (i != null) {
        printer(i.toString());
      }
    }
  });
  Logger.root.level = level;

  final logger = name == null ? Logger.root : Logger(name);

  return logger;
}
