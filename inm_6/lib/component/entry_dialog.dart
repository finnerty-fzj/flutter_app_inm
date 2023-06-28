// ignore_for_file: depend_on_referenced_packages

import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:inm_6/utils/user.dart';
import 'package:inm_6/data/data.dart' as data_provider;
import 'package:intl/intl.dart';

class EntryDialog extends StatefulWidget {
  const EntryDialog({super.key});
  @override
  State<EntryDialog> createState() => _EntryDialogState();
}

class _EntryDialogState extends State<EntryDialog> {
  final formKey = GlobalKey<FormBuilderState>();
  final List<String> dropDownOptions = ["k", "ff", "nop", "tx", "Rx"];
  User newUser = User.empty();

  void parseSelectedUser(String value) {
    List<String> splitted = value.split(", ");
    newUser.name = splitted[0];
    newUser.vorname = splitted[1];
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          FormBuilderDropdown<String>(
            name: 'Nanme, Vorname',
            initialValue: "${newUser.name}, ${newUser.vorname}",
            onSaved: (newValue) => {parseSelectedUser(newValue!)},
            decoration: const InputDecoration(
              labelText: 'Nanme, Vorname',
            ),
            validator: FormBuilderValidators.compose(
                [FormBuilderValidators.required()]),
            items: data_provider.names
                .map((item) => DropdownMenuItem(
                      alignment: AlignmentDirectional.bottomStart,
                      value: item,
                      child: Text(item),
                    ))
                .toList(),
            valueTransformer: (val) => val?.toString(),
          ),
          FormBuilderDropdown<String>(
            name: 'Grund',
            initialValue: newUser.grund,
            onSaved: (newValue) => {newUser.grund = newValue},
            decoration: const InputDecoration(
              labelText: 'Grund',
            ),
            validator: FormBuilderValidators.compose(
                [FormBuilderValidators.required()]),
            items: dropDownOptions
                .map((item) => DropdownMenuItem(
                      alignment: AlignmentDirectional.bottomStart,
                      value: item,
                      child: Text(item),
                    ))
                .toList(),
            valueTransformer: (val) => val?.toString(),
          ),
          FormBuilderDateTimePicker(
            name: 'Von',
            format: DateFormat('dd-MM-yyyy'),
            initialEntryMode: DatePickerEntryMode.calendarOnly,
            initialValue: DateFormat('dd.MM.yyyy').parse(newUser.von!),
            inputType: InputType.date,
            onSaved: (value) =>
                {newUser.von = "${value?.day}.${value?.month}.${value?.year}"},
            initialTime: const TimeOfDay(hour: 8, minute: 0),
            valueTransformer: (value) =>
                "${value?.day}.${value?.month}.${value?.year}",
          ),
          FormBuilderDateTimePicker(
            name: 'Bis',
            format: DateFormat('dd-MM-yyyy'),
            initialValue: DateFormat('dd.MM.yyyy').parse(newUser.bis!),
            initialEntryMode: DatePickerEntryMode.calendarOnly,
            inputType: InputType.date,
            onSaved: (value) =>
                {newUser.bis = "${value?.day}.${value?.month}.${value?.year}"},
            initialTime: const TimeOfDay(hour: 8, minute: 0),
            valueTransformer: (value) =>
                "${value?.day}.${value?.month}.${value?.year}",
          ),
          FormBuilderTextField(
            name: "Beschreibung",
            initialValue: newUser.beschreibung,
            onSaved: (newValue) => {newUser.beschreibung = newValue},
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
              FormBuilderValidators.maxLength(200)
            ]),
            maxLines: 2,
            keyboardType: TextInputType.multiline,
            decoration: const InputDecoration(
              labelText: 'Beschreibung',
              contentPadding: EdgeInsets.only(
                bottom: 3,
                top: 4,
              ),
            ),
          ),
          const SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                width: 100,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade300),
                  onPressed: () {
                    formKey.currentState!.reset();
                  },
                  child: const Text(
                    'Clear',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              SizedBox(
                width: 125,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade300),
                  onPressed: () {
                    formKey.currentState!.validate();
                    formKey.currentState!.save();
                    data_provider.insertNewEntry(newUser);
                    ElegantNotification.success(
                            title: Text("Update"),
                            description: Text("Your data has been updated"))
                        .show(context);
                    formKey.currentState!.reset();
                  },
                  child: const Text(
                    'Bestätigen',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
