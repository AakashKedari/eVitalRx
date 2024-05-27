import 'package:evital/app/customWidgets/textField.dart';
import 'package:evital/app/modules/login/controllers/login_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:velocity_x/velocity_x.dart';

class LoginView extends StatelessWidget {
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  final LoginController loginController = Get.put(LoginController());
  final _formKey = GlobalKey<FormState>();

  LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('Login')),
      body: Padding(
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
                    style: TextStyle(fontSize: 50, fontWeight: FontWeight.w200),
                  )),
              CustomTextField(
                hint: 'Mobile No.',
                loginController: loginController,
                textEditingController: _mobileController,
              ),
              const Gap(10),
              CustomTextField(
                loginController: loginController,
                hint: 'Password',
                textEditingController: _passwordController,
              ),
              const SizedBox(height: 20),
              Obx(() => loginController.isLoading.value
                  ? SizedBox(
                      height: 80,
                      child: LoadingIndicator(
                          indicatorType: Indicator.ballClipRotatePulse,

                          /// Required, The loading type of the widget
                          colors: [Colors.blue.shade300],

                          /// Optional, The color collections
                          strokeWidth: 2,

                          /// Optional, The stroke of the line, only applicable to widget which contains line
                          backgroundColor: Colors.transparent,

                          /// Optional, Background of the widget
                          pathBackgroundColor: Colors.transparent

                          /// Optional, the stroke backgroundColor
                          ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: MaterialButton(
                        height: 40,
                        minWidth: double.infinity,
                        shape: StadiumBorder(),
                        color: Colors.blue.shade300,
                        onPressed: () {
                          /// If the user presses the elevated button instead of Done Button
                          /// on the keyboard, we unfocus  the FocusScope to remove the
                          /// Keyboard
                          FocusScope.of(context).unfocus();
                          if (_formKey.currentState!.validate()) {
                            String mobile = _mobileController.text;
                            String password = _passwordController.text;
                            loginController.login(mobile, password);
                          }
                        },
                        child: 'Login'.text.make(),
                      ),
                    )),
            ],
          ),
        ),
      ),
    );
  }
}
