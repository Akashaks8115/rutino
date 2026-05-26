import 'dart:io';

void main() {
  final dir = Directory('c:/Flutter Pojects/rutino/lib');
  final files = dir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));

  for (final file in files) {
    String content = file.readAsStringSync();
    
    // Replace .withOpacity(x) with .withValues(alpha: x)
    final regex = RegExp(r'\.withOpacity\(([^)]+)\)');
    if (regex.hasMatch(content)) {
      content = content.replaceAllMapped(regex, (match) {
        return '.withValues(alpha: ${match.group(1)})';
      });
      file.writeAsStringSync(content);
      print('Fixed in ${file.path}');
    }
  }
}
