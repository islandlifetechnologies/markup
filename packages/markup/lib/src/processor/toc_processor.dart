import 'package:json_annotation/json_annotation.dart';

import '../../markup.dart';

part 'toc_processor.g.dart';

class TocProcessor(
  super.section, {
  super.postProcessor = true,
  super.type = kType,
}) extends MarkupProcessor {
  this {
    _params = _Params.fromJson((section as MarkupDirective).params);
  }

  static const kType = 'toc';

  static const _maxLevel = 6;
  static final _fenceRegEx = RegExp(r'^(?<fence>```+)(?<name>\S*)?');
  static final _linkRegEx = RegExp(r'(?<title>\[.*\])(?<link>\(.*\))?');
  static final _titleRegEx = RegExp(r'^(?<level>#+)(?<title>\s+(.*))$');

  late final _Params _params;

  @override
  MarkupOutput process(MarkdownDocument doc) {
    final lines = _removeComments(
      doc.sections.skip(doc.indexOf(section)).join('\n'),
    ).split('\n');
    final toc = <_TocEntry>[];

    final slugs = <String>{};

    var depth = 1;
    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      final codeMatch = _fenceRegEx.firstMatch(line.trim());
      if (codeMatch != null) {
        final fence = codeMatch.namedGroup('fence')!;
        for (var j = i + 1; j < lines.length; j++) {
          final l = lines[j].trim();
          final endMatch = _fenceRegEx.firstMatch(l);
          if (endMatch != null && fence == endMatch.namedGroup('fence')) {
            i = j;
            break;
          }
        }
        continue;
      }

      final match = _titleRegEx.firstMatch(line);
      if (match != null) {
        final level = match.namedGroup('level')!.length;

        logger.finer('TOC: ${match.group(0)}: $level');

        if (level > _maxLevel) {
          continue;
        }

        if (depth < level) {
          depth++;
        } else if (depth > level) {
          depth = level;
        }

        var title = match.namedGroup('title')!.trim();

        final linkMatch = _linkRegEx.firstMatch(title);

        if (linkMatch != null) {
          title = linkMatch.namedGroup('title')!;
        }
        title = title.replaceAll(RegExp(r'[`\[\]\(\)\*]'), '');

        while (title.startsWith('_') && title.endsWith('_')) {
          title = title.substring(1, title.length - 1);
        }
        final slug = title
            .toLowerCase()
            .replaceAll(RegExp(r'[^a-z0-9\s-_]'), '')
            .replaceAll(RegExp(r'\s+'), '-');

        var realSlug = slug;
        var count = 1;
        while (slugs.contains(realSlug)) {
          realSlug = '$slug-$count';
          count++;
        }
        slugs.add(realSlug);
        toc.add(_TocEntry(level: depth, slug: realSlug, title: title));
      }
    }

    final buf = StringBuffer();
    final minLevel = toc.fold<int>(
      6,
      (previousValue, element) =>
          element.level < previousValue ? element.level : previousValue,
    );

    for (final entry in toc) {
      final indent = '  ' * (entry.level - minLevel);
      buf.writeln('$indent${_params.bullet} [${entry.title}](#${entry.slug})');
    }

    return MarkupOutput.fromSection(buf.toString(), section: section);
  }

  String _removeComments(String input) {
    final buf = StringBuffer();
    var pattern = '';
    var inComment = false;
    for (final ch in input.split('')) {
      if (inComment) {
        if (ch == '-' && (pattern == '' || pattern == '-')) {
          pattern += ch;
        } else if (ch == '>' && pattern == '--') {
          inComment = false;
          pattern = '';
        } else {
          pattern = '';
        }
      } else if (ch == '<') {
        pattern = ch;
      } else if (ch == '!' && pattern == '<') {
        pattern += ch;
      } else if (ch == '-' && pattern == '<!') {
        pattern += ch;
      } else if (ch == '-' && pattern == '<!-') {
        pattern = '';
        inComment = true;
      } else {
        pattern = '';
        buf.write(ch);
      }
    }

    return buf.toString();
  }
}

@JsonSerializable(createToJson: false)
class _Params({final String? bullet = '-'}) {
  factory fromJson(Map<String, dynamic> json) => _$ParamsFromJson(json);
}

class _TocEntry({
  required final int level,
  required final String slug,
  required final String title,
});
