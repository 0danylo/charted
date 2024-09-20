import 'package:flutter/material.dart';

const placeholderGraphName = "018eujosbnd8192er1hue";
final placeholderDateTime = DateTime(1969);

const red = Color.fromARGB(255, 179, 25, 66);
const blue = Color.fromARGB(255, 0, 98, 194);
const yellow = Color.fromARGB(255, 255, 191, 0);
const darkColor = Color.fromARGB(255, 31, 31, 31);
const lightColor = Color.fromARGB(255, 195, 195, 195);
const white = Colors.white;
const invisible = Colors.transparent;

const smallStyle = TextStyle(color: white, fontSize: 15);
const mediumStyle = TextStyle(color: white, fontSize: 18);
const largeStyle = TextStyle(color: white, fontSize: 24);
const subtitleStyle = TextStyle(color: white, fontSize: 30);
const titleStyle = TextStyle(color: white, fontSize: 40);
const errorStyle = TextStyle(color: red);
const warningStyle = TextStyle(color: yellow);
const labelStyle = TextStyle(color: lightColor);

const buttonStyle = ButtonStyle(
    backgroundColor: WidgetStatePropertyAll(white),
    textStyle: WidgetStatePropertyAll(mediumStyle));

const months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec'
];

coalesceDateTime(DateTime date, TimeOfDay time) =>
    DateTime(date.year, date.month, date.day, time.hour, time.minute);

getSortedEntries(Map data) {
  var entries = data.entries.toList();
  entries.sort((a, b) => a.key.compareTo(b.key));
  return entries;
}

getStepEntries(Map data) {
  var original = getSortedEntries(data);
  if (original.isEmpty) {
    return original;
  }

  var newList = [original[0]];

  for (var i = 1; i < original.length; i++) {
    newList.addAll([
      MapEntry(
        original[i].key.add(const Duration(milliseconds: -1)),
        original[i - 1].value,
      ),
      original[i]
    ]);
  }

  return newList;
}

formatDate(DateTime date) =>
    styled('${months[date.month - 1]} ${date.day} ${date.year}');
formatTime(TimeOfDay time) => styled(
    '${time.hourOfPeriod}:${time.minute > 9 ? time.minute : '0${time.minute}'} ${time.period.name.toUpperCase()}');
formatDouble(double x) => x.toInt() == x ? x.toInt().toString() : x.toString();

smallStyled(String text) => Text(text, style: smallStyle);
styled(String text) => Text(text, style: mediumStyle);
largeStyled(String text) => Text(text, style: largeStyle);
subtitleOf(String text) =>
    Text(text, style: subtitleStyle, textAlign: TextAlign.center);
titleOf(String text) =>
    Text(text, style: titleStyle, textAlign: TextAlign.center);

errorOf(String text) => Text(text, style: errorStyle);
warningOf(String text) => Text(text, style: warningStyle);

getPadding(double side) => Padding(padding: EdgeInsets.all(side));
