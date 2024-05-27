import 'dart:io';

import 'package:path_provider/path_provider.dart';

get localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

get localFile async {
  final path = await localPath;
  return File('$path/data.txt');
}

writeGraph(name, type) async {
  final file = await localFile;

  file.writeAsString('$name ${type.toString()}\n\n', mode: FileMode.append);
}



writeDatum(name, date, datum) async {
  final file = await localFile;
  final contents = await file.readAsString();

  final nameIndex = contents.indexOf(name);
  final insertIndex = contents.indexOf('\n\n', nameIndex);
  final updatedContents = contents.substring(0, insertIndex) +
      '\n${date.millisecondsSinceEpoch} $datum' +
      contents.substring(insertIndex);

  file.writeAsString(updatedContents);
}

readFile() async {
  final file = await localFile;
  final contents = await file.readAsString();
  return contents;
}
