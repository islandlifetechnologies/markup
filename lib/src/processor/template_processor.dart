import 'dart:io';

import 'package:json_annotation/json_annotation.dart';
import 'package:markup/markup.dart';
import 'package:template_expressions/template_expressions.dart';

part 'template_processor.g.dart';

class TemplateProcessor(super.directive, {super.type = kType})
    extends MarkupProcessor {
  this {
    _params = _Params.fromJson((section as MarkupDirective).params);
  }
  static const kType = 'template';

  late final _Params _params;

  @override
  MarkupOutput process(MarkdownDocument doc) {
    final pFile = _params.file;
    final pContext = _params.context;

    final context = <String, dynamic>{};
    String templateStr;

    if (pContext != null) {
      for (final entry in pContext.entries) {
        final template = Template(
          entry.value?.toString() ?? 'null',
          syntax: [_params.syntax.syntax],
        );
        context[entry.key] = template.evaluate();
        logger.finest('Context: ${entry.key} = ${context[entry.key]}');
      }
    }

    if (pFile != null) {
      final file = getEntity<File>(doc, pFile);

      if (!file.existsSync()) {
        throw MarkupException.fromSection(
          section,
          'Unable to locate template file: ${file.absolute.path}',
        );
      }
      templateStr = file.readAsStringSync();
    } else {
      templateStr = _params.template!;
    }
    final template = Template(
      templateStr,
      context: context,
      syntax: [_params.syntax.syntax],
    );

    return MarkupOutput.fromSection(template.process(), section: section);
  }
}

@JsonSerializable()
class _Params({
  final Map<String, dynamic>? context = const {},
  final String? file,
  final _TemplateSyntax syntax = _TemplateSyntax.standard,
  final String? template,
}) {
  this : assert(file != null || template != null);

  factory fromJson(Map<String, dynamic> json) => _$ParamsFromJson(json);
}

enum _TemplateSyntax(final ExpressionSyntax syntax) {
  hash(HashExpressionSyntax()),
  mustache(MustacheExpressionSyntax()),
  standard(StandardExpressionSyntax()),
  pipe(PipeExpressionSyntax());
}
