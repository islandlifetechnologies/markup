import 'dart:async';
import 'dart:io';

import 'package:logging/logging.dart';
import 'package:path/path.dart' as p;
import 'package:template_expressions/template_expressions.dart';

import '../../markup.dart';

typedef FileSystemEntityBuilder = T Function<T extends FileSystemEntity>(
  String path,
);

abstract class MarkupProcessor(
  final MarkupSection section, {

  /// Defines if the processor is meant to run after the first pass of
  /// processing.  This should only be true when the processor utilizes output
  /// of other processors.
  final bool postProcessor = false,

  required String type,
}) {
  this {
    final dType = section.type;
    if (type != dType) {
      throw MarkupException.fromSection(
        section,
        '$runtimeType: "$type" != "$dType"',
      );
    }
    logger = Logger(runtimeType.toString());
  }
  late final Logger logger;

  static bool _isAbsolute(String path) {
    if (Platform.isWindows) {
      return path.startsWith(RegExp(r'^(?:\\\\|[a-zA-Z]:[/\\])'));
    } else {
      return path.startsWith('/');
    }
  }

  F getEntity<F extends FileSystemEntity>(MarkdownDocument doc, String path) {
    final cd = Directory(p.dirname(doc.path));

    final builder = switch (F) {
      Directory => Directory.new,
      File => File.new,
      _ => throw Exception('Unknown entity type: $F'),
    };

    path = Template(
      path,
      context: {'PWD': Directory('.').absolute.path},
    ).process();

    final entity = _isAbsolute(path)
        ? builder(path)
        : builder(p.join(cd.absolute.path, path));

    return entity as F;
  }

  /// Process the given source [doc].  This then returns the output that needs
  /// to be added to the document.
  FutureOr<MarkupOutput> process(MarkdownDocument doc);
}
