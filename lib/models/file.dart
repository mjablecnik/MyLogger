import 'package:flogs/core/constants.dart';

class File {
  final String name;
  final String? path;
  final FileType? type;

  const File({
    required this.name,
    this.type,
    this.path,
  });
}
