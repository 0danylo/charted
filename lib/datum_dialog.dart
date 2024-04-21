import 'package:flutter/material.dart';

class DatumDialog extends StatefulWidget {
  const DatumDialog({super.key, required this.graphName});

  final String graphName;

  @override
  State<StatefulWidget> createState() => DatumDialogState();
}

class DatumDialogState extends State<DatumDialog> {
  var newDate = DateTime.now();
  var newTime = TimeOfDay.now();
  var newDatum;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
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
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    ).then(
                        (value) => setState(() => newDate = value ?? newDate));
                  },
                  child: const Text("Set date")),
              Text(newDate.toString()),
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
              Text(newTime.toString()),
            ],
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: "Value:"),
            keyboardType: const TextInputType.numberWithOptions(
                signed: true, decimal: true),
            // inputFormatters: [
            //   FilteringTextInputFormatter.allow(RegExp(r"[0-9.\-]")),
            // ],
            onChanged: (value) => setState(() {
              var match = RegExp("[+-]?([0-9]*[.])?[0-9]+").firstMatch(value);
              newDatum =
                  match != null ? double.parse(match.group(0)!) : newDatum;
            }),
          ),
          ElevatedButton(
              onPressed: newDatum == null
                  ? null
                  : () {
                      Navigator.of(context).pop();
                    },
              child: const Text("Okay"))
        ],
      ),
    );
  }
}
