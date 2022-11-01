import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/app_prefs.dart';
import 'package:flutter_application_1/app/network_aware_widget.dart';
import 'package:flutter_application_1/presentation/errorDialogHendler/dialog.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_application_1/app/di.dart';
import 'package:flutter_application_1/presentation/resources/color_manager.dart';
import 'package:flutter_application_1/presentation/resources/routes_manager.dart';
import 'package:flutter_application_1/presentation/resources/strings_manager.dart';
import 'package:flutter_application_1/presentation/resources/values_manager.dart';
import 'package:flutter_application_1/services/auth_services.dart';
import 'package:lottie/lottie.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final AppPreferences _appPreferences = instance<AppPreferences>();

  String? token;
  String? email;
  String? forgetpasswordEmail;
  String? password;

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('reset password'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const Text('Please enter your email'),
                Lottie.asset('assets/json/password.json',
                    width: 100, height: 100),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                  onChanged: (value) {
                    forgetpasswordEmail = value;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('send'),
              onPressed: () {
                AuthServices().forgetpassword(forgetpasswordEmail);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  var userNameController = TextEditingController();
  var passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NetworkAwareWidget(
        onlineChild: SafeArea(
          child: Scaffold(
              backgroundColor: ColorManager.white,
              body: Container(
                padding: const EdgeInsets.only(top: AppPadding.p8),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/images/logo.png",
                          width: AppSize.s180,
                          height: AppSize.s180,
                        ),
                        const SizedBox(height: AppSize.s28),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: AppPadding.p28, right: AppPadding.p28),
                          child: TextFormField(
                            validator: (userNameController) {
                              if (userNameController == null ||
                                  userNameController.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                            onChanged: (val) {
                              email = val;
                            },
                            keyboardType: TextInputType.emailAddress,
                            controller: userNameController,
                            decoration: const InputDecoration(
                              hintText: AppStrings.username,
                              labelText: AppStrings.username,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSize.s28),
                        //this is a password textformfild widget with invisible password and icon button to show password
                        Padding(
                          padding: const EdgeInsets.only(
                              left: AppPadding.p28, right: AppPadding.p28),
                          child: TextFormField(
                            validator: (passwordController) {
                              if (passwordController == null ||
                                  passwordController.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                            onChanged: (val) {
                              password = val;
                            },
                            keyboardType: TextInputType.visiblePassword,
                            controller: passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              hintText: AppStrings.password,
                              labelText: AppStrings.password,
                            ),
                          ),
                        ),

                        const SizedBox(height: AppSize.s65),
                        Padding(
                            padding: const EdgeInsets.only(
                                left: AppPadding.p28, right: AppPadding.p28),
                            child: SizedBox(
                              width: double.infinity,
                              height: AppSize.s40,
                              child: ElevatedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      AuthServices()
                                          .login(email, password)
                                          .then((value) {
                                        if (value?.accessToken != null) {
                                          _appPreferences.setIsUserLoggedIn();
                                          _appPreferences
                                              .setId(value?.id as int);
                                          _appPreferences.setToken(
                                              value?.accessToken as String);
                                          _appPreferences
                                              .setEmail(value?.email as String);
                                          Navigator.pushReplacementNamed(
                                              context, Routes.mainRoute);
                                          print(_appPreferences.getToken());
                                        }
                                      });
                                    }
                                  },
                                  child: const Text(AppStrings.login)),
                            )),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: AppPadding.p28,
                              right: AppPadding.p28,
                              top: AppPadding.p60),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomWidgets.socialButtonCircle(
                                  ColorManager.google,
                                  FontAwesomeIcons.googlePlusG,
                                  iconColor: Colors.white,
                                  onTap: () {}),
                              const SizedBox(
                                width: AppSize.s12,
                              ),
                              CustomWidgets.socialButtonCircle(
                                  ColorManager.facebook,
                                  FontAwesomeIcons.facebookF,
                                  iconColor: Colors.white, onTap: () async {
                                final result = await FacebookAuth.instance
                                    .login(permissions: [
                                  'email',
                                  'public_profile'
                                ]);
                                if (result.status == LoginStatus.success) {
                                  final requestData = await FacebookAuth.i
                                      .getUserData(
                                          fields:
                                              'id,name,email,picture.type(large)');

                                  setState(() {});
                                } else {
                                  ErrorDialog2().showCustomDialog(
                                      context,
                                      'something went wrong',
                                      'assets/json/connection_error.json');
                                }
                              }),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: AppPadding.p28,
                            left: AppPadding.p28,
                            right: AppPadding.p28,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  _showMyDialog();
                                },
                                child: Text(AppStrings.forgetPassword,
                                    style:
                                        Theme.of(context).textTheme.subtitle2),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                      context, Routes.registerRoute);
                                },
                                child: Text(AppStrings.registerText,
                                    style:
                                        Theme.of(context).textTheme.subtitle2),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )),
        ),
        offlineChild: const Center(child: Text("No Internet Connection")));
  }
}
