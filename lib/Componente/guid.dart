import 'dart:math';

String generateGuid() {
  final random = Random();
  final bytes = List<int>.generate(16, (index) => random.nextInt(256));
  final guid =
  bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join('');
  return '${guid.substring(0, 8)}-${guid.substring(8, 12)}-${guid.substring(12, 16)}-${guid.substring(16, 20)}-${guid.substring(20)}';
}