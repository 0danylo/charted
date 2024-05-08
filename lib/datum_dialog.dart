import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:trend_notes/main.dart';
import 'package:trend_notes/util.dart';

class DatumDialog extends StatefulWidget {
  const DatumDialog({super.key, required this.graphName});

  final String graphName;

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
          Title(
              color: const Color.fromARGB(255, 106, 106, 106),
              child: subtitleOf("Add datum to ${widget.graphName}")),
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
                          DateTime.now().add(const Duration(days: 365240)),
                    ).then(
                        (value) => setState(() => newDate = value ?? newDate));
                  },
                  style: buttonStyle,
                  child: const Text("Set date")),
              formatDate(newDate),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                  onPressed: () {
                    showTimePicker(
                            context: context, initialTime: TimeOfDay.now())
                        .then((value) =>
                            setState(() => newTime = value ?? newTime));
                  },
                  style: buttonStyle,
                  child: const Text("Set time")),
              formatTime(newTime),
            ],
          ),
          TextFormField(
            style: mediumStyle,
            decoration: const InputDecoration(
                labelText: "Value:", labelStyle: labelStyle),
            keyboardType: const TextInputType.numberWithOptions(
                signed: true, decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.deny(RegExp(r",")),
              LengthLimitingTextInputFormatter(307),
            ],
            onChanged: (value) => setState(() {
              var match = RegExp("[+-]?([0-9]*[.])?[0-9]+").firstMatch(value);
              newDatum = match != null ? double.parse(match.group(0)!) : null;
            }),
          ),
          errorOf(newDatum == null ? "Invalid value" : ""),
          ElevatedButton(
              onPressed: newDatum == null
                  ? null
                  : () {
                      appState.data.update(widget.graphName, (value) {
                        value[DateTime(newDate.year, newDate.month, newDate.day,
                            newTime.hour, newTime.minute)] = newDatum;
                        return value;
                      }, ifAbsent: () => {newDate: newDatum});

                      Navigator.of(context).pop();
                      appState.notify();
                    },
              style: buttonStyle,
              child: const Text("Add"))
        ],
      ),
    );
  }
}
