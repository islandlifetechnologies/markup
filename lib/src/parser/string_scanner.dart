import 'dart:collection';

class StringScanner(final List<String> lines) extends IterableBase<String> {
  factory fromString(String input) => StringScanner(input.split('\n'));

  var _offset = -1;

  bool get hasNext => _offset < lines.length;

  @override
  Iterator<String> get iterator => _StringScannerIterator(this);

  @override
  int get length => lines.length;

  int get offset => _offset;
}

class _StringScannerIterator implements Iterator<String> {
  _StringScannerIterator(this.scanner);

  final StringScanner scanner;

  @override
  String get current => scanner.lines[scanner._offset];

  @override
  bool moveNext() {
    ++scanner._offset;
    return scanner.hasNext;
  }
}
