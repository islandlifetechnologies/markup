import 'dart:io';

import 'package:markup_common/markup_common.dart';

void main(List<String> args) {
  final logger = initLogging();
  var mmdcInstalled = false;
  try {
    final result = Process.runSync('mmdc', ['--version']);
    if (result.exitCode == 0) {
      mmdcInstalled = true;
    }
  } catch (e) {
    // no-op
  }

  if (!mmdcInstalled) {
    try {
      logger.info('mmdc not installed, attempting to install');
      final result = Process.runSync('npm', [
        'install',
        '-g',
        '@mermaid-js/mermaid-cli',
      ]);
      if (result.exitCode == 0) {
        mmdcInstalled = true;
      }
    } catch (e) {
      // no-op
    }
  }

  if (!mmdcInstalled) {
    logger.info('Unable to install mmdc.  Aborting!');
    exit(1);
  }
}
