import 'package:flutter/material.dart';

class FieldData {
  String _labelText;
  TextInputType _keyboardType;
  final TextEditingController controller;
  final FocusNode focusNode;

  final FormFields field;

  String get labelText => this._labelText;
  TextInputType get keyboardType => this._keyboardType;

  FieldData(
      {@required this.field,
      @required this.controller,
      @required this.focusNode}) {
    this._labelText = _generateLabelText();
    this._keyboardType = assignKeyboardType();
  }

  String _generateLabelText() {
    switch (this.field) {
      case FormFields.FirstName:
        return "First Name";
        break;
      case FormFields.LastName:
        return "Last Name";
        break;
      case FormFields.dob:
        return "Date Of Birth";
        break;
      case FormFields.Email:
        return "Email Id";
        break;
      case FormFields.MobileNo:
        return "Mobile No";
        break;
      case FormFields.Country:
        return "Country";
        break;
      case FormFields.State:
        return "State";
        break;
      case FormFields.City:
        return "City";
        break;
      default:
        return "Unknown";
        break;
    }
  }

  TextInputType assignKeyboardType() {
    switch (this.field) {
      case FormFields.FirstName:
      case FormFields.LastName:
      case FormFields.Country:
      case FormFields.State:
      case FormFields.City:
      case FormFields.dob:
        return TextInputType.text;
        break;
      case FormFields.Email:
        return TextInputType.emailAddress;
        break;
      case FormFields.MobileNo:
        return TextInputType.numberWithOptions();
        break;
      default:
        return TextInputType.text;
        break;
    }
  }
}

enum FormFields {
  FirstName,
  LastName,
  dob,
  Email,
  MobileNo,
  Country,
  State,
  City
}
