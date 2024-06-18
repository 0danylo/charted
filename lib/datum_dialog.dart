import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:charted/file_util.dart';
import 'package:charted/main.dart';
import 'package:charted/style_util.dart';

class DatumDialog extends StatefulWidget {
  final String name;
  final Map<DateTime, double> data;

  const DatumDialog({super.key, required this.name, required this.data});

  @override
  State<StatefulWidget> createState() => DatumDialogState();
}

class DatumDialogState extends State<DatumDialog> {
  var newDate = DateTime.now();
  var newTime = TimeOfDay.now();
  var newDatum = null;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MainPageState>();

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
                                  primary: blue, secondary: lightColor)),
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
                                    primary: blue, secondary: lightColor)),
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
                      final newDateTime = DateTime(newDate.year, newDate.month,
                          newDate.day, newTime.hour, newTime.minute);

                      appState.data.update(widget.name, (value) {
                        value[newDateTime] = newDatum;
                        return value;
                      }, ifAbsent: () => {newDateTime: newDatum});

                      writeDatum(widget.name, newDateTime, newDatum);
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
