<!-- markup:template {"template": "The answer to life is: ${20 * 2 + 2}"} /-->

<!-- markup:template
context:
  pubspec: ${yaon.decode(File('pubspec.yaml').readAsStringSync())}
template: |
  ```yaml
  dependencies:
    ${pubspec.name}: ^${pubspec.version}
  ```
/-->
