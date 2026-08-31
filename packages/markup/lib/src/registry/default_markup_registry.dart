import 'package:markup/markup.dart';

class DefaultMarkupRegistry({Map<String, ProcessorBuilder>? builders})
    extends MarkupRegistry {
  this
    : super(
        builders: {
          DrawIoProcessor.kType: DrawIoProcessor.new,
          FileProcessor.kType: FileProcessor.new,
          ProcessProcessor.kType: ProcessProcessor.new,
          TemplateProcessor.kType: TemplateProcessor.new,
          TocProcessor.kType: TocProcessor.new,
          ...?builders,
        },
      );
}
