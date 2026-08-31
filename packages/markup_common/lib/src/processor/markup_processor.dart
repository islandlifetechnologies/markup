import 'dart:async';
import 'dart:io';

import 'package:markup_common/markup_common.dart';
import 'package:path/path.dart' as p;

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

  /// Processes the directive and returns the generated output.  The [docPath]
  /// is the absolute path to the markdown document being processed.
  FutureOr<MarkupOutput> process(MarkdownDocument doc);

  /// Post processes the directive.  The passed in [sections] will include the
  /// output of all directives that are not post processors.  This will only be
  /// called if the processor is a post processor.  The [docPath] is the
  /// absolute path to the markdown document being processed.
  FutureOr<MarkupOutput> postProcess(MarkdownDocument doc) =>
      throw UnimplementedError('Not a post processor');
}
