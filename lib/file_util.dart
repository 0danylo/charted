import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:trend_notes/graph_card.dart';

get localFile async {
  final path = (await getApplicationDocumentsDirectory()).path;
  return File('$path/data.txt');
}

readFile() async {
  final file = await localFile;
  final contents = await file.readAsString();
  return contents;
}

writeGraph(name) async {
  final file = await localFile;

  file.writeAsString('$name ${GraphType.lineWithPoints.toString()}\n\n',
      mode: FileMode.append);
  print('FILE:\n' + await readFile());
}

writeDatum(name, dateTime, datum) async {
  final file = await localFile;
  final contents = await file.readAsString();

  final nameIndex = contents.indexOf(name);
  final insertIndex = contents.indexOf('\n\n', nameIndex);
  final updatedContents = contents.substring(0, insertIndex) +
      '\n${dateTime.millisecondsSinceEpoch} $datum' +
      contents.substring(insertIndex);

  file.writeAsString(updatedContents);

  print('FILE:\n' + await readFile());
}

editType(name, type) async {
  final file = await localFile;
  final contents = await file.readAsString();

  final nameIndex = contents.indexOf(name);
  final rowEndIndex = contents.indexOf('\n', nameIndex);

  file.writeAsString(contents.substring(0, nameIndex) +
      '$name $type' +
      contents.substring(rowEndIndex));
      
  print('FILE:\n' + await readFile());
}

eraseGraph(name) async {
  final file = await localFile;
  final contents = await file.readAsString();

  final nameIndex = contents.indexOf(name);
  final lastIndex = contents.indexOf('\n\n', nameIndex) + 2;

  file.writeAsString(
      contents.substring(0, nameIndex) + contents.substring(lastIndex));
  print('FILE:\n' + await readFile());
}

eraseDatum(name, dateTime) async {
  final file = await localFile;
  final contents = await file.readAsString();

  final nameIndex = contents.indexOf(name);
  final dateIndex = contents.indexOf(dateTime.millisecondsSinceEpoch, nameIndex);
  final lastIndex = contents.indexOf('\n', dateIndex) + 1;

  file.writeAsString(
      contents.substring(0, dateIndex) + contents.substring(lastIndex));
  print('FILE:\n' + await readFile());
}
