import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/models/model.dart';
import 'package:flutter_application_1/presentation/login/login.dart';
import 'package:flutter_application_1/presentation/resources/color_manager.dart';

import 'package:flutter_application_1/presentation/resources/strings_manager.dart';
import 'package:flutter_application_1/presentation/resources/values_manager.dart';
import 'package:flutter_application_1/services/auth_services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'password is required'),
    MinLengthValidator(8, errorText: 'password must be at least 8 digits long'),
    PatternValidator(r'(?=.*?[#?!@$%^&*-])',
        errorText: 'passwords must have at least one special character')
  ]);
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  String? fullName;
  String? phone;
  DateTime birthday = DateTime(2022, 02, 21);
  bool userStatus = true;
  String? address;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      body: Container(
        padding: const EdgeInsets.only(top: AppPadding.p20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 250),
                  child: FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginView()),
                      );
                    },
                    child: const Icon(Icons.arrow_back),
                  ),
                ),
                Image.asset(
                  "assets/images/logo.png",
                  width: AppSize.s100,
                  height: AppSize.s100,
                ),
                const SizedBox(height: AppSize.s28),
                Padding(
                  padding: const EdgeInsets.only(
                      left: AppPadding.p28, right: AppPadding.p28),
                  child: TextFormField(
                    validator:
                        EmailValidator(errorText: 'user name is required'),
                    onChanged: (val) {
                      email = val;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: 'Email',
                      labelText: "Email",
                    ),
                  ),
                ),
                const SizedBox(height: AppSize.s28),
                Padding(
                    padding: const EdgeInsets.only(
                        left: AppPadding.p28, right: AppPadding.p28),
                    child: TextFormField(
                      validator: passwordValidator,
                      onChanged: (val) {
                        password = val;
                      },
                      keyboardType: TextInputType.visiblePassword,
                      decoration: const InputDecoration(
                        hintText: AppStrings.password,
                        labelText: AppStrings.password,
                      ),
                    )),
                const SizedBox(height: AppSize.s28),
                Padding(
                    padding: const EdgeInsets.only(
                        left: AppPadding.p28, right: AppPadding.p28),
                    child: TextFormField(
                      validator: (val) =>
                          MatchValidator(errorText: 'passwords do not match')
                              .validateMatch(val!, password!),
                      onChanged: (val) {
                        val = val;
                      },
                      keyboardType: TextInputType.visiblePassword,
                      decoration: const InputDecoration(
                        hintText: "confirm password ",
                        labelText: "confirm password ",
                      ),
                    )),
                const SizedBox(height: AppSize.s28),
                Padding(
                    padding: const EdgeInsets.only(
                        left: AppPadding.p28, right: AppPadding.p28),
                    child: TextFormField(
                      validator: RequiredValidator(
                          errorText: "this filed is required"),
                      keyboardType: TextInputType.visiblePassword,
                      decoration: const InputDecoration(
                        hintText: "Full Name",
                        labelText: "Full Name",
                      ),
                      onChanged: (val) {
                        fullName = val;
                      },
                    )),
                const SizedBox(height: AppSize.s28),
                Padding(
                    padding: const EdgeInsets.only(
                        left: AppPadding.p28, right: AppPadding.p28),
                    child: TextFormField(
                      validator: RequiredValidator(
                          errorText: "this filed is required"),
                      keyboardType: TextInputType.visiblePassword,
                      decoration: const InputDecoration(
                        hintText: "address",
                        labelText: "address",
                      ),
                      onChanged: (val) {
                        address = val;
                      },
                    )),
                const SizedBox(height: AppSize.s28),
                Padding(
                    padding: const EdgeInsets.only(
                        left: AppPadding.p16, right: AppPadding.p8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Birthday :",
                          style: TextStyle(color: ColorManager.darkGrey),
                        ),
                        const SizedBox(
                          width: AppSize.s200,
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              DateTime? newDate = await showDatePicker(
                                  context: context,
                                  initialDate: birthday,
                                  firstDate: DateTime(1950),
                                  lastDate: DateTime(2200));
                              if (newDate == null) return;
                              setState(() {
                                birthday = newDate;
                              });
                            },
                            child: const Icon(Icons.date_range)),
                      ],
                    )),
                const SizedBox(height: AppSize.s12),
                Padding(
                  padding: const EdgeInsets.only(
                      left: AppPadding.p28,
                      right: AppPadding.p28,
                      bottom: AppPadding.p12),
                  child: InternationalPhoneNumberInput(
                    onInputChanged: (PhoneNumber val) {
                      phone = val.toString();
                    },
                    onSaved: (value) => phone = value.toString(),
                    selectorConfig: const SelectorConfig(
                      selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                    ),
                    ignoreBlank: false,
                    autoValidateMode: AutovalidateMode.onUserInteraction,
                    selectorTextStyle: const TextStyle(color: Colors.black),
                    //  initialValue: phone,
                    formatInput: false,
                    keyboardType: const TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    inputBorder: const OutlineInputBorder(),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(
                        left: AppPadding.p28, right: AppPadding.p28),
                    child: SizedBox(
                      width: double.infinity,
                      height: AppSize.s60,
                      child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              AuthServices().register(
                                  email,
                                  password,
                                  fullName,
                                  phone.toString(),
                                  birthday.toString(),
                                  userStatus,
                                  address);
                            }
                          },
                          child: const Text('register')),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
