import 'package:flogs/core/constants.dart';

class LogFile {
  final String name;
  final String? path;
  final FileType? type;

  const LogFile({
    required this.name,
    this.type,
    this.path,
  });
}
