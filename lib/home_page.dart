import 'package:flutter/material.dart';
import 'package:voya_test/database.dart';

import 'data_model/field_data.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<FieldData> fieldsData = [];
  double _screenHeight;
  double _screenWidth;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    FormFields.values.forEach((element) {
      fieldsData.add(FieldData(
          field: element,
          controller: TextEditingController(),
          focusNode: FocusNode()));
    });
    super.initState();
  }

  @override
  void dispose() {
    fieldsData.forEach((element) {
      element.controller.dispose();
      element.focusNode.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _screenHeight = MediaQuery.of(context).size.height / 100;
    _screenWidth = MediaQuery.of(context).size.width / 100;
    return Scaffold(
      appBar: AppBar(
        title: Text("Form Test"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: _screenWidth * 5, vertical: _screenHeight * 2),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildTextField(FormFields.FirstName),
                    ),
                    SizedBox(width: _screenWidth * 2),
                    Expanded(
                      child: _buildTextField(FormFields.LastName),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildDatePicker(FormFields.DateOfBirth)),
                    SizedBox(width: _screenWidth * 2),
                    Expanded(child: _buildGenderRadioButton(FormFields.Gender)),
                  ],
                ),
                _buildTextField(FormFields.Email),
                _buildTextField(FormFields.MobileNo),
                _buildDropDownField(FormFields.Country),
                _buildDropDownField(FormFields.State),
                _buildDropDownField(FormFields.City),
                SizedBox(
                  height: _screenHeight * 2,
                ),
                RaisedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      fieldsData.forEach((element) {
                        print(element.controller.text);
                      });
                    }
                  },
                  child: Text('SUBMIT'),
                  color: Colors.green,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(FormFields field) {
    FieldData data = fieldsData.firstWhere((element) => element.field == field);
    return Container(
      margin: EdgeInsets.only(bottom: _screenHeight * 2),
      child: TextFormField(
        controller: data.controller,
        focusNode: data.focusNode,
        keyboardType: data.keyboardType,
        decoration: _decoration(data.labelText),
        validator: (val) => _validate(val, data),
        onChanged: (val) {
          if (data.controller.text != val) {
            data.controller.text = val;
          }
        },
      ),
    );
  }

  Widget _buildGenderRadioButton(FormFields field) {
    FieldData data = fieldsData.firstWhere((element) => element.field == field);
    return Container(
      margin: EdgeInsets.only(bottom: _screenHeight * 2),
      child: FormField(
          initialValue: data.controller.text, // Changed
          validator: (val) => _validate(val, data),
          builder: (fieldState) {
            return InputDecorator(
              decoration: _decoration(data.labelText)
                  .copyWith(errorText: fieldState.errorText),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'MALE',
                    style: TextStyle(fontSize: _screenWidth * 3),
                  ),
                  Container(
                    height: 24.0,
                    width: _screenWidth * 4,
                    alignment: Alignment.centerRight,
                    child: Radio<String>(
                        activeColor: Colors.red,
                        value: '0',
                        groupValue: fieldState.value,
                        onChanged: (val) {
                          fieldState.didChange(val);
                          setState(() {
                            data.controller.text = 'MALE';
                          });
                        }),
                  ),
                  Text(
                    'FEMALE',
                    style: TextStyle(fontSize: _screenWidth * 3),
                  ),
                  Container(
                    height: 24.0,
                    width: _screenWidth * 4,
                    alignment: Alignment.centerRight,
                    child: Radio<String>(
                        activeColor: Colors.red,
                        value: '1',
                        groupValue: fieldState.value,
                        onChanged: (val) {
                          fieldState.didChange(val);
                          setState(() {
                            data.controller.text = 'FEMALE';
                          });
                        }),
                  )
                ],
              ),
            );
          }),
    );
  }

  Widget _buildDatePicker(FormFields field) {
    FieldData data = fieldsData.firstWhere((element) => element.field == field);

    return Container(
      margin: EdgeInsets.only(bottom: _screenHeight * 2),
      child: FormField(
          initialValue: data.controller.text.isEmpty
              ? data.labelText
              : data.controller.text,
          validator: (val) => _validate(val, data),
          builder: (fieldState) {
            return InputDecorator(
              decoration: _decoration(
                      data.controller.text.isEmpty ? '' : data.labelText)
                  .copyWith(errorText: fieldState.errorText),
              child: InkWell(
                onTap: () async {
                  DateTime lastDate =
                      DateTime.now().subtract(Duration(days: 365 * 15));
                  DateTime lastSelectedDate = data.controller.text.isEmpty
                      ? lastDate
                      : DateTime.tryParse(data.controller.text) ?? lastDate;
                  // Initial date is the selected date

                  DateTime pickedDate = await showDatePicker(
                      context: context,
                      initialDate: lastSelectedDate,
                      firstDate: DateTime(1900),
                      lastDate: lastDate);
                  if (pickedDate != null) {
                    fieldState.didChange(
                        '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}');
                    setState(() {
                      data.controller.text = fieldState.value;
                    });
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(fieldState.value.toString()),
                    Icon(Icons.calendar_today_sharp),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Widget _buildDropDownField(FormFields field) {
    FieldData data = fieldsData.firstWhere((element) => element.field == field);
    List<String> dropdownValues;
    if (field == FormFields.Country) {
      dropdownValues = DataBase.getCountries();
    } else if (field == FormFields.State) {
      dropdownValues = DataBase.getStates(getCountryName());
    } else if (field == FormFields.City) {
      dropdownValues = DataBase.getCities(getCountryName(), getStateName());
    }

    return Container(
      margin: EdgeInsets.only(bottom: _screenHeight * 2),
      child: DropdownButtonFormField(
        focusNode: data.focusNode,
        decoration: _decoration(data.labelText),
        validator: (val) => _validate(val, data),
        items: dropdownValues
            .map((e) => DropdownMenuItem<String>(
                  child: Text(e),
                  value: e,
                ))
            .toList(),
        onChanged: (value) {
          if (data.controller.text != value) {
            setState(() {
              data.controller.text = value;
              if (field == FormFields.State) {
                fieldsData
                    .firstWhere((element) => element.field == FormFields.City)
                    .controller
                    .text = '';
              }
            });
          }
        },
        value: data.controller.text != '' ? data.controller.text : null,
        selectedItemBuilder: (_) => dropdownValues.map((e) => Text(e)).toList(),
      ),
    );
  }

  String getCountryName() {
    String countryName = fieldsData
        .firstWhere((element) => element.field == FormFields.Country)
        .controller
        .text;
    if (countryName.isEmpty) {
      countryName = 'India';
    }
    return countryName;
  }

  String getStateName() {
    String stateName = fieldsData
        .firstWhere((element) => element.field == FormFields.State)
        .controller
        .text;
    if (stateName.isEmpty) {
      stateName = 'West Bengal';
    }
    return stateName;
  }

  InputDecoration _decoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      border: OutlineInputBorder(),
    );
  }

  String _validate(String val, FieldData data) {
    String errorText;
    switch (data.field) {
      case FormFields.FirstName:
      case FormFields.LastName:
        if (val.isEmpty) {
          errorText = 'Enter ${data.labelText}';
        }
        break;
      case FormFields.Email:
        if (!val.contains('@')) {
          errorText = 'Please enter a valid ${data.labelText}';
        }
        break;
      case FormFields.MobileNo:
        if (val.length != 10) {
          errorText = 'Please enter a valid ${data.labelText}';
        }
        break;
      case FormFields.Country:
      case FormFields.State:
      case FormFields.City:
        if (data.controller.text.isEmpty) {
          errorText = 'Please select a ${data.labelText}';
        }
        break;
      case FormFields.DateOfBirth:
        if (val == null || val == data.labelText) {
          errorText = 'Select ${data.labelText}';
        }
        break;
      case FormFields.Gender:
        if (data.controller.text.isEmpty) {
          errorText = 'Please select ${data.labelText}';
        }
        break;

      default:
        errorText = null;
        break;
    }
    return errorText;
  }
}
