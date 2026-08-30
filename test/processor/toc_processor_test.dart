import 'dart:io';

import 'package:markup/markup.dart';
import 'package:test/test.dart';

void main() {
  final scanner = MarkdownScanner.fromFile(File('test/assets/toc.md'));
  final doc = scanner.scan();

  test('no params', () async {
    final directive = doc[1] as MarkupDirective;

    final result = TocProcessor(directive).process(doc);
    expect(result.contents, _table('-'));
  });

  test('plus', () async {
    final directive = doc[3] as MarkupDirective;

    final result = TocProcessor(directive).process(doc);
    expect(result.contents, _table('+'));
  });

  test('star', () async {
    final directive = doc[5] as MarkupDirective;

    final result = TocProcessor(directive).process(doc);
    expect(result.contents, _table('*'));
  });
}

String _table(String bullet) =>
    '''
<!-- markup:output -->
$bullet [1](#1)
  $bullet [2](#2)
    $bullet [3](#3)
      $bullet [4](#4)
        $bullet [5](#5)
          $bullet [6](#6)
$bullet [Scenario](#scenario)
  $bullet [Title With Spaces](#title-with-spaces)
  $bullet [Title with backticks](#title-with-backticks)
  $bullet [Sp3c!@l Ch@rs](#sp3cl-chrs)
  $bullet [snake_case_title](#snake_case_title)
  $bullet [Google](#google)
$bullet [Skip Depths](#skip-depths)
  $bullet [Skipped](#skipped)
$bullet [Repeats](#repeats)
  $bullet [Repeat](#repeat)
    $bullet [Repeat](#repeat-1)
  $bullet [Repeat](#repeat-2)
    $bullet [Repeat](#repeat-3)
  $bullet [Repeat](#repeat-4)
$bullet [Comments](#comments)
$bullet [Fence](#fence)
<!-- /markup:output -->
''';
