import 'package:flutter/material.dart';

const darkColor = Color.fromARGB(255, 31, 31, 31);
const lightColor = Color.fromARGB(255, 195, 195, 195);
const white = Colors.white;

const smallStyle = TextStyle(color: white, fontSize: 15);
const mediumStyle = TextStyle(color: white, fontSize: 20);
const subtitleStyle = TextStyle(color: white, fontSize: 30);
const titleStyle = TextStyle(color: white, fontSize: 40);
const errorStyle = TextStyle(color: Colors.red);
const labelStyle = TextStyle(color: lightColor);

const buttonStyle = ButtonStyle(
    backgroundColor: MaterialStatePropertyAll(white),
    textStyle: MaterialStatePropertyAll(mediumStyle));

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

formatDate(DateTime date) =>
    styled('${months[date.month - 1]} ${date.day} ${date.year}');

formatTime(TimeOfDay time) => styled(
    '${time.hourOfPeriod}:${time.minute > 9 ? time.minute : '0${time.minute}'} ${time.period.name.toUpperCase()}');

formatDouble(double x) => x.toInt() == x ? x.toInt().toString() : x.toString();

styled(String text) => Text(text, style: mediumStyle);
subtitleOf(String text) => Text(text, style: subtitleStyle);
titleOf(String text) => Text(text, style: titleStyle);
errorOf(String text) => Text(text, style: errorStyle);

getPadding(double side) => Padding(padding: EdgeInsets.all(side));
