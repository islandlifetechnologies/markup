import 'package:file/local.dart';
import 'package:markup_common/markup_common.dart';

typedef ProcessorBuilder = MarkupProcessor Function(
  MarkupSection section, {
  required MarkupRegistry registry,
});

class MarkupRegistry({
  Map<String, ProcessorBuilder>? builders,
  FileSystem? fs,
}) {
  this : fs = fs ?? LocalFileSystem() {
    if (builders != null) {
      _builders.addAll(builders);
    }
  }

  final Map<String, ProcessorBuilder> _builders = {};

  final FileSystem fs;
  final _logger = Logger('MarkupRegistry');

  /// Creates a processor for the given directive.
  MarkupProcessor create(MarkupSection section) {
    _logger.config('Create builder: ${section.type}');
    final builder = _builders[section.type];

    if (builder == null) {
      throw Exception(
        'Unable to locate directive builder for: [${section.type}]',
      );
    }

    return builder(section, registry: this);
  }

  MarkupProcessor? maybeCreate(MarkupSection section) {
    _logger.config('Maybe builder: ${section.type}');
    final builder = _builders[section.type];

    return builder?.call(section, registry: this);
  }

  void registerBuilder(String type, ProcessorBuilder builder) {
    final exists = _builders.containsKey(type);
    if (exists) {
      _logger.config('Replacing builder: $type');
    } else {
      _logger.config('Registered builder: $type');
    }

    _builders[type] = builder;
  }
}
