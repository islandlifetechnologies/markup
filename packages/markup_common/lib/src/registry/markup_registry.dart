import 'package:markup_common/markup_common.dart';

typedef ProcessorBuilder = MarkupProcessor Function(MarkupSection section);

class MarkupRegistry({Map<String, ProcessorBuilder>? builders}) {
  this {
    if (builders != null) {
      _builders.addAll(builders);
    }
  }

  final Map<String, ProcessorBuilder> _builders = {};

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

    return builder(section);
  }

  MarkupProcessor? maybeCreate(MarkupSection section) {
    _logger.config('Maybe builder: ${section.type}');
    final builder = _builders[section.type];

    return builder?.call(section);
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
