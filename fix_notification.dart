import 'dart:io';

void main() {
  final file = File('c:/Flutter Pojects/rutino/lib/screens/focus/service/notification_service.dart');
  String content = file.readAsStringSync();
  
  // Remove uiLocalNotificationDateInterpretation
  content = content.replaceAll(RegExp(r'uiLocalNotificationDateInterpretation\s*:\s*UILocalNotificationDateInterpretation\.absoluteTime\s*,'), '');
  
  // Add import if missing
  if (!content.contains('notification_router_manager.dart')) {
    content = content.replaceFirst("import '../../../../libs.dart';", "import '../../../../libs.dart';\nimport 'package:rutino/screens/focus/service/notification_router_manager.dart';");
  }

  file.writeAsStringSync(content);
}
