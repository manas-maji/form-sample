import 'package:flutter/material.dart';
import 'package:voya_test/database.dart';
import 'package:voya_test/ui_model/date_form_field.dart';

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
            horizontal: _screenWidth * 10, vertical: _screenHeight * 2),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextField(FormFields.FirstName),
                _buildTextField(FormFields.LastName),
                _buildDatePicker(FormFields.dob),
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

  Widget _buildDatePicker(FormFields field) {
    FieldData data = fieldsData.firstWhere((element) => element.field == field);

    // return FormField(
    //     validator: (val) => _validate(val, data),
    //     builder: (_) {
    //       return Container(
    //         margin: EdgeInsets.only(bottom: _screenHeight * 2),
    //         child: Column(
    //           children: [
    //             InputDecorator(
    //               decoration: _decoration(
    //                   data.controller.text.isEmpty ? '' : data.labelText),
    //               child: Row(
    //                 children: [
    //                   Expanded(
    //                       child: Text(data.controller.text.isNotEmpty
    //                           ? data.controller.text
    //                           : data.labelText)),
    //                   IconButton(
    //                     icon: Icon(Icons.calendar_today_sharp),
    //                     onPressed: () async {
    //                       DateTime lastDate =
    //                           DateTime.now().subtract(Duration(days: 365 * 15));
    //                       DateTime pickedDate = await showDatePicker(
    //                           context: context,
    //                           initialDate: lastDate,
    //                           firstDate: DateTime(1900),
    //                           lastDate: lastDate);
    //
    //                       // update date in controller
    //                       setState(() {
    //                         data.controller.text = pickedDate.toString();
    //                       });
    //                     },
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ],
    //         ),
    //       );
    //     });
    return Container(
      margin: EdgeInsets.only(bottom: _screenHeight * 2),
      child: DateFormField(
        context: context,
        decoration:
            _decoration(data.controller.text.isEmpty ? '' : data.labelText),
        initialValue: data.controller.text.isEmpty
            ? data.labelText
            : data.controller.text,
        validator: (val) => _validate(val, data),
        onChanged: (val) {
          if (data.controller.text != val) {
            print('Controller text : ${data.controller.text}');
            print('new value: $val');
            setState(() {
              data.controller.text = val;
            });
            print('Controller text : ${data.controller.text}');
            print('new value: $val');
          }
        },
      ),
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
          errorText = '${data.labelText} can\'t be empty';
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
      case FormFields.dob:
        if (val.isEmpty || val == null || val == data.labelText) {
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
