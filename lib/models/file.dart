import 'package:f_logs/constants/constants.dart';

class File {
  final String name;
  final String? path;
  final FileType type;

  const File({
    required this.name,
    required this.type,
    this.path,
  });
}
