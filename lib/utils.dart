import 'package:flutter/material.dart';

const darkColor = Color.fromARGB(255, 31, 31, 31);
const lightColor = Color.fromARGB(255, 195, 195, 195);
const white = Colors.white;

const buttonStyle = ButtonStyle(backgroundColor: MaterialStatePropertyAll(darkColor));

formatDate(DateTime date) => '${date.year}/${date.month}/${date.day}';

formatTime(TimeOfDay time) =>
    '${time.hourOfPeriod}:${time.minute > 9 ? time.minute : '0${time.minute}'} ${time.period.name.toUpperCase()}';
