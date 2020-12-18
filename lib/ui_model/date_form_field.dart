import 'package:flutter/material.dart';

class DateFormField extends FormField<String> {
  final ValueChanged<String> onChanged;
  final InputDecoration decoration;
  final BuildContext context;

  DateFormField({
    Key key,
    String initialValue,
    this.context,
    this.decoration = const InputDecoration(),
    this.onChanged,
    onSaved,
    validator,
  })  : assert(decoration != null),
        assert(initialValue != null),
        super(
          key: key,
          onSaved: onSaved,
          initialValue: initialValue,
          validator: validator,
          builder: (FormFieldState field) {
            final InputDecoration effectiveDecoration =
                decoration.applyDefaults(
              Theme.of(field.context).inputDecorationTheme,
            );
            return InputDecorator(
              decoration:
                  effectiveDecoration.copyWith(errorText: field.errorText),
              child: InkWell(
                onTap: () async {
                  DateTime lastDate =
                      DateTime.now().subtract(Duration(days: 365 * 15));
                  
                  DateTime pickedDate = await showDatePicker(
                      context: context,
                      initialDate: lastDate,
                      firstDate: DateTime(1900),
                      lastDate: lastDate);
                  if (pickedDate != null) {
                    field.didChange(pickedDate.toString());
                    onChanged(field.value);
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(field.value.toString()),
                    Icon(Icons.calendar_today_sharp),
                  ],
                ),
              ),
            );
          },
        );
}
