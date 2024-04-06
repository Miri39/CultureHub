import 'Event.dart';

import 'package:flutter/material.dart';
import 'package:date_picker_plus/date_picker_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Form',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyForm(),
    );
  }
}

class MyForm extends StatefulWidget {
  const MyForm({super.key});

  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _textFieldController = TextEditingController();
  late Event event;

  @override
  Widget build(BuildContext context) {
    event = Event();
    return Scaffold(
      resizeToAvoidBottomInset : false,
      appBar: AppBar(
        title: const Text('Event Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _textFieldController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Event name',
                ),
                onChanged: (value){
                  event.name = value;
                },
              ),
          RangeDatePicker(
            minDate: DateTime(2021, 1, 1),
            maxDate: DateTime(2024, 12, 31),
            onRangeSelected: (value) {
              // Handle selected range
              event.dateTimeRange = value;
            },
          ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // If the form is valid, display a snackbar.
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Processing Data'),
                        ),
                      );
                    print(event.name);
                    print(event.dateTimeRange);
                    }
                  },
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DateIntervalPicker extends StatefulWidget {
  @override
  _DateIntervalPickerState createState() => _DateIntervalPickerState();
}

class _DateIntervalPickerState extends State<DateIntervalPicker> {
  late DateTime _startDate;
  late DateTime _endDate;

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now(),
      firstDate: _startDate ?? DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text("Start Date"),
          subtitle: Text(_startDate != null
              ? "${_startDate.day}/${_startDate.month}/${_startDate.year}"
              : "Select start date"),
          onTap: () => _selectStartDate(context),
        ),
        ListTile(
          title: Text("End Date"),
          subtitle: Text(_endDate != null
              ? "${_endDate.day}/${_endDate.month}/${_endDate.year}"
              : "Select end date"),
          onTap: () => _selectEndDate(context),
        ),
      ],
    );
  }
}
