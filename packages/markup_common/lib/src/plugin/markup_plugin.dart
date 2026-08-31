import 'dart:convert';
import 'dart:io';

import 'package:markup_common/markup_common.dart';

class MarkupPlugin({required final String directive}) {
  late final logger = Logger('plugin:$directive');

  Future<void> process() async {
    final bytes = <int>[];

    int byte;
    while ((byte = stdin.readByteSync()) != -1) {
      bytes.add(byte);
    }

    final data = utf8.decode(bytes);
    final section = MarkupDirective.fromJson(json.decode(data));

    if (directive != section.type) {
      throw Exception(
        'Unexpected plugin directive: ${section.type} != $directive',
      );
    }
  }
}
