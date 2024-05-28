import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:trend_notes/graph_card.dart';

getNameIndex(contents, name) {
  var row = '';
  for (var line in contents.split('\n')) {
    if (line != '' && line.substring(0, line.lastIndexOf(' ')) == name) {
      row = line;
    }
  }

  return contents.indexOf(row);
}

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

  file.writeAsString('$name lineWithPoints\n\n', mode: FileMode.append);
}

writeDatum(name, dateTime, datum) async {
  final file = await localFile;
  final contents = await file.readAsString();

  final nameIndex = getNameIndex(contents, name); //fail?
  final insertIndex = contents.indexOf('\n\n', nameIndex);
  final updatedContents = contents.substring(0, insertIndex) +
      '\n${dateTime.millisecondsSinceEpoch} $datum' +
      contents.substring(insertIndex);

  file.writeAsString(updatedContents);
}

editType(name, GraphType type) async {
  final file = await localFile;
  final contents = await file.readAsString();

  final nameIndex = getNameIndex(contents, name);
  final rowEndIndex = contents.indexOf('\n', nameIndex);

  file.writeAsString(contents.substring(0, nameIndex) +
      '$name ${type.name}' +
      contents.substring(rowEndIndex));
}

eraseGraph(name) async {
  final file = await localFile;
  final contents = await file.readAsString();

  final nameIndex = getNameIndex(contents, name);
  final lastIndex = contents.indexOf('\n\n', nameIndex) + 2;

  file.writeAsString(
      contents.substring(0, nameIndex) + contents.substring(lastIndex));
}

eraseDatum(name, DateTime dateTime) async {
  final file = await localFile;
  final contents = await file.readAsString();

  final nameIndex = getNameIndex(contents, name);
  final dateIndex =
      contents.indexOf(dateTime.millisecondsSinceEpoch.toString(), nameIndex);
  final lastIndex = contents.indexOf('\n', dateIndex) + 1;

  file.writeAsString(
      contents.substring(0, dateIndex) + contents.substring(lastIndex));
}
