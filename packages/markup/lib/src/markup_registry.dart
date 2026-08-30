import 'package:logging/logging.dart';

import '../markup.dart';

typedef ProcessorBuilder = MarkupProcessor Function(MarkupDirective section);

class MarkupRegistry({Map<String, ProcessorBuilder>? builders}) {
  this {
    _builders.addAll({
      DrawIoProcessor.kType: DrawIoProcessor.new,
      FileProcessor.kType: FileProcessor.new,
      ProcessProcessor.kType: ProcessProcessor.new,
      TemplateProcessor.kType: TemplateProcessor.new,
      TocProcessor.kType: TocProcessor.new,
      ...?builders,
    });
  }

  final Map<String, ProcessorBuilder> _builders = {};

  final _logger = Logger('MarkupRegistry');

  /// Creates a processor for the given directive.
  MarkupProcessor create(MarkupDirective section) {
    _logger.config('Create builder: ${section.type}');
    final builder = _builders[section.type];

    if (builder == null) {
      throw Exception(
        'Unable to locate directive builder for: [${section.type}]',
      );
    }

    return builder(section);
  }

  MarkupProcessor? maybeCreate(MarkupDirective directive) {
    _logger.config('Maybe builder: ${directive.type}');
    final builder = _builders[directive.type];

    return builder?.call(directive);
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
