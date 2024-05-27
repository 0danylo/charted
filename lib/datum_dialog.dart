import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:trend_notes/function_util.dart';
import 'package:trend_notes/main.dart';
import 'package:trend_notes/style_util.dart';

class DatumDialog extends StatefulWidget {
  const DatumDialog({super.key, required this.name});

  final String name;

  @override
  State<StatefulWidget> createState() => DatumDialogState();
}

class DatumDialogState extends State<DatumDialog> {
  var newDate = DateTime.now();
  var newTime = TimeOfDay.now();
  var newDatum = null;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    return AlertDialog(
      backgroundColor: darkColor,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          subtitleOf('Add datum to ${widget.name}'),
          getPadding(5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                  onPressed: () {
                    showDatePicker(
                      context: context,
                      firstDate: DateTime.fromMillisecondsSinceEpoch(0),
                      lastDate:
                          DateTime.now().add(const Duration(days: 365241)),
                      builder: (context, child) => Theme(
                          data: ThemeData.dark().copyWith(
                              colorScheme: const ColorScheme.dark(
                                  primary: Color.fromARGB(255, 0, 100, 255),
                                  secondary: lightColor)),
                          child: child!),
                    ).then(
                        (value) => setState(() => newDate = value ?? newDate));
                  },
                  style: buttonStyle,
                  child: const Text('Set date')),
              formatDate(newDate),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                  onPressed: () {
                    showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                      builder: (BuildContext context, Widget? child) {
                        return Theme(
                            data: ThemeData.dark().copyWith(
                                colorScheme: const ColorScheme.dark(
                                    primary: Color.fromARGB(255, 0, 100, 255),
                                    secondary: lightColor)),
                            child: MediaQuery(
                              data: MediaQuery.of(context)
                                  .copyWith(alwaysUse24HourFormat: false),
                              child: child!,
                            ));
                      },
                    ).then(
                        (value) => setState(() => newTime = value ?? newTime));
                  },
                  style: buttonStyle,
                  child: const Text('Set time')),
              formatTime(newTime),
            ],
          ),
          TextFormField(
            style: mediumStyle,
            decoration: const InputDecoration(
                labelText: 'Value:', labelStyle: labelStyle),
            keyboardType: const TextInputType.numberWithOptions(
                signed: true, decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.deny(RegExp(r',')),
              LengthLimitingTextInputFormatter(307),
            ],
            onChanged: (value) => setState(() {
              var match = RegExp('[+-]?([0-9]*[.])?[0-9]+').firstMatch(value);
              newDatum = match != null ? double.parse(match.group(0)!) : null;
            }),
          ),
          errorOf(newDatum == null ? 'Invalid value' : ''),
          ElevatedButton(
              onPressed: newDatum == null
                  ? null
                  : () {
                      appState.data.update(widget.name, (value) {
                        value[DateTime(newDate.year, newDate.month, newDate.day,
                            newTime.hour, newTime.minute)] = newDatum;
                        return value;
                      }, ifAbsent: () => {newDate: newDatum});

                      writeDatum(widget.name, newDate, newDatum);
                      Navigator.of(context).pop();
                      appState.notify();
                    },
              style: buttonStyle,
              child: const Text('Add'))
        ],
      ),
    );
  }
}
