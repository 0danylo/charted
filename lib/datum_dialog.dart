import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:trend_notes/main.dart';
import 'package:trend_notes/utils.dart';

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
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Title(
              color: const Color.fromARGB(255, 106, 106, 106),
              child: Text("${widget.graphName} - New data point")),
          Row(
            children: [
              ElevatedButton(
                  onPressed: () {
                    var date = showDatePicker(
                      context: context,
                      firstDate: DateTime.fromMillisecondsSinceEpoch(0),
                      lastDate:
                          DateTime.now().add(const Duration(days: 365240)),
                    ).then(
                        (value) => setState(() => newDate = value ?? newDate));
                  },
                  child: const Text("Set date")),
              Text(formatDate(newDate)),
            ],
          ),
          Row(
            children: [
              ElevatedButton(
                  onPressed: () {
                    var time = showTimePicker(
                            context: context, initialTime: TimeOfDay.now())
                        .then((value) =>
                            setState(() => newTime = value ?? newTime));
                  },
                  child: const Text("Set time")),
              Text(formatTime(newTime)),
            ],
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: "Value:"),
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
              child: const Text("Okay")),
          if (newDatum == null)
            const Text("Invalid value",
                style: TextStyle(color: Color.fromARGB(195, 255, 0, 0)))
        ],
      ),
    );
  }
}
