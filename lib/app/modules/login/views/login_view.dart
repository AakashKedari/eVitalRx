import 'package:evital/app/customWidgets/textField.dart';
import 'package:evital/app/modules/login/controllers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:velocity_x/velocity_x.dart';

class LoginView extends StatelessWidget {
  final LoginController loginController = Get.put(LoginController());
  final _formKey = GlobalKey<FormState>();

  LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('eVitalRx'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue,
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.blue,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Sign In',
                          style: TextStyle(
                              fontSize: 50, fontWeight: FontWeight.normal),
                        )),
                    CustomTextField(
                      hint: 'Mobile No.',
                      loginController: loginController,
                      textEditingController: loginController.mobileController,
                    ),
                    const Gap(10),
                    CustomTextField(
                      loginController: loginController,
                      hint: 'Password',
                      textEditingController: loginController.passwordController,
                    ),
                    const SizedBox(height: 20),
                    Obx(() => loginController.isLoading.value
                        ? SizedBox(
                            height: 80,
                            child: LoadingIndicator(
                                indicatorType: Indicator.ballClipRotatePulse,
                                colors: [Colors.blue.shade300],
                                strokeWidth: 2,
                                backgroundColor: Colors.transparent,
                                pathBackgroundColor: Colors.transparent),
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: MaterialButton(
                              elevation: 10,
                              splashColor: Colors.white,
                              textColor: Colors.white,
                              height: 40,
                              minWidth: double.infinity,
                              shape: const StadiumBorder(),
                              color: Colors.blue,
                              onPressed: () {
                                /// If the user presses the elevated button instead of Done Button
                                /// on the keyboard, we unfocus  the FocusScope to remove the
                                /// Keyboard
                                FocusScope.of(context).unfocus();
                                if (_formKey.currentState!.validate()) {
                                  String mobile =
                                      loginController.mobileController.text;
                                  String password =
                                      loginController.passwordController.text;
                                  loginController.login(mobile, password);
                                }
                              },
                              child: 'Login'.text.make(),
                            ),
                          ))
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
