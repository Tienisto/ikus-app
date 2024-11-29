import 'package:flutter/material.dart';
import 'package:ikus_app/components/buttons/ovgu_button.dart';
import 'package:ikus_app/components/info_text.dart';
import 'package:ikus_app/components/inputs/ovgu_text_field.dart';
import 'package:ikus_app/components/main_list_view.dart';
import 'package:ikus_app/components/popups/error_popup.dart';
import 'package:ikus_app/components/popups/generic_text_popup.dart';
import 'package:ikus_app/gen/strings.g.dart';
import 'package:ikus_app/model/event.dart';
import 'package:ikus_app/service/api_service.dart';
import 'package:ikus_app/service/calendar_service.dart';
import 'package:ikus_app/utility/globals.dart';
import 'package:ikus_app/utility/ui.dart';

class RegisterEventScreen extends StatefulWidget {

  final int eventId;
  final List<RegistrationField> requiredFields;

  const RegisterEventScreen({required this.eventId, required this.requiredFields});

  @override
  _RegisterEventScreenState createState() => _RegisterEventScreenState();
}

class _RegisterEventScreenState extends State<RegisterEventScreen> {

  final _matriculationNoController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _countryController = TextEditingController();
  String _matriculationNo = '';
  String _firstName = '';
  String _lastName = '';
  String _email = '';
  String _address = '';
  String _country = '';

  @override
  void initState() {
    super.initState();

    // load autofill

    final data = CalendarService.instance.getEventRegistrationData();
    if (data.matriculationNumber != null) {
      _matriculationNo = data.matriculationNumber!.toString();
      _matriculationNoController.text = _matriculationNo;
    }

    if (data.firstName != null) {
      _firstName = data.firstName!;
      _firstNameController.text = _firstName;
    }

    if (data.lastName != null) {
      _lastName = data.lastName!;
      _lastNameController.text = _lastName;
    }

    if (data.email != null) {
      _email = data.email!;
      _emailController.text = _email;
    }

    if (data.address != null) {
      _address = data.address!;
      _addressController.text = _address;
    }

    if (data.country != null) {
      _country = data.country!;
      _countryController.text = _country;
    }
  }

  Future<void> register() async {

    // validation
    bool error = false;
    for (final field in widget.requiredFields) {
      switch (field) {
        case RegistrationField.MATRICULATION_NUMBER:
          if (int.tryParse(_matriculationNo) == null)
            error = true;
          break;
        case RegistrationField.FIRST_NAME:
          if (_firstName.trim().isEmpty)
            error = true;
          break;
        case RegistrationField.LAST_NAME:
          if (_lastName.trim().isEmpty)
            error = true;
          break;
        case RegistrationField.EMAIL:
          if (_email.trim().isEmpty)
            error = true;
          break;
        case RegistrationField.ADDRESS:
          if (_address.trim().isEmpty)
            error = true;
          break;
        case RegistrationField.COUNTRY:
          if (_country.trim().isEmpty)
            error = true;
          break;
      }
    }

    if (error) {
      ErrorPopup.open(context, message: t.registerEvent.errors.validation);
      return;
    }

    DateTime start = DateTime.now();
    GenericTextPopup.open(context: context, text: t.registerEvent.registering);

    await CalendarService.instance.saveEventRegistrationAutofill(
        matriculationNumber: int.tryParse(_matriculationNo),
        firstName: _firstName,
        lastName: _lastName,
        email: _email,
        address: _address,
        country: _country
    );

    try {
      final token = await ApiService.registerEvent(
        eventId: widget.eventId,
        matriculationNumber: widget.requiredFields.contains(RegistrationField.MATRICULATION_NUMBER) ? int.tryParse(_matriculationNo) : null,
        firstName: widget.requiredFields.contains(RegistrationField.FIRST_NAME) ? _firstName : null,
        lastName: widget.requiredFields.contains(RegistrationField.LAST_NAME) ? _lastName : null,
        email: widget.requiredFields.contains(RegistrationField.EMAIL) ? _email : null,
        address: widget.requiredFields.contains(RegistrationField.ADDRESS) ? _address : null,
        country: widget.requiredFields.contains(RegistrationField.COUNTRY) ? _country : null,
      );

      await CalendarService.instance.sync(useNetwork: true);
      // at least 1sec popup time
      await sleepRemaining(1000, start);
      Navigator.pop(context);

      await CalendarService.instance.saveEventRegistrationToken(widget.eventId, token);
      Navigator.pop(context);
    } catch (e) {
      Navigator.pop(context);
      switch (e) {
        case 403:
          ErrorPopup.open(context, message: t.registerEvent.errors.closed);
          break;
        case 409:
          ErrorPopup.open(context, message: t.registerEvent.errors.full);
          break;
        default:
          ErrorPopup.open(context);
          break;
      }
    }
  }

  Widget getInputField(RegistrationField field, FocusScopeNode node) {
    TextEditingController controller;
    String hint;
    switch (field) {
      case RegistrationField.MATRICULATION_NUMBER:
        controller = _matriculationNoController;
        hint = t.registerEvent.matriculationNumber;
        break;
      case RegistrationField.FIRST_NAME:
        controller = _firstNameController;
        hint = t.registerEvent.firstName;
        break;
      case RegistrationField.LAST_NAME:
        controller = _lastNameController;
        hint = t.registerEvent.lastName;
        break;
      case RegistrationField.EMAIL:
        controller = _emailController;
        hint = t.registerEvent.email;
        break;
      case RegistrationField.ADDRESS:
        controller = _addressController;
        hint = t.registerEvent.address;
        break;
      case RegistrationField.COUNTRY:
        controller = _countryController;
        hint = t.registerEvent.country;
        break;
    }

    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(hint),
          SizedBox(height: 5),
          OvguTextField(
              controller: controller,
              hint: hint,
              onEditingComplete: () => node.nextFocus(),
              onChange: (value) {
                setState(() {
                  switch (field) {
                    case RegistrationField.MATRICULATION_NUMBER:
                      _matriculationNo = value;
                      break;
                    case RegistrationField.FIRST_NAME:
                      _firstName = value;
                      break;
                    case RegistrationField.LAST_NAME:
                      _lastName = value;
                      break;
                    case RegistrationField.EMAIL:
                      _email = value;
                      break;
                    case RegistrationField.ADDRESS:
                      _address = value;
                      break;
                    case RegistrationField.COUNTRY:
                      _country = value;
                      break;
                  }
                });
              }
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(t.registerEvent.title),
      ),
      body: MainListView(
        children: [
          SizedBox(height: 20),
          ...widget.requiredFields.map((f) => getInputField(f, node)),
          SizedBox(height: 30),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: InfoText(t.registerEvent.disclaimer)
          ),
          SizedBox(height: 20),
          Padding(
            padding: OvguPixels.mainScreenPadding,
            child: Align(
              alignment: Alignment.centerRight,
              child: UnconstrainedBox(
                child: OvguButton(
                  callback: register,
                  child: Row(
                    children: [
                      Text(t.registerEvent.register, style: TextStyle(color: Colors.white)),
                      SizedBox(width: 10),
                      Icon(Icons.send, color: Colors.white)
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 50)
        ],
      ),
    );
  }
}
