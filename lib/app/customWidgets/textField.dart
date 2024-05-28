import 'package:flutter/material.dart';

import '../modules/login/controllers/login_controller.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.textEditingController,
    required this.loginController,
    required this.hint,
  });

  final TextEditingController textEditingController;
  final LoginController loginController;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      color: Colors.white,
      surfaceTintColor: Colors.white,
      child: TextFormField(
        cursorColor: Colors.blue,
        obscureText: hint == 'Password' ? true : false,
        autocorrect: hint == 'Password' ? false : true,
        controller: textEditingController,
        decoration: InputDecoration(
            labelStyle: const TextStyle(color: Colors.blue),
            prefixIcon: Icon(hint != 'Password' ? Icons.phone : Icons.lock),
            contentPadding:
                const EdgeInsets.only(left: 10, top: 10, bottom: 10),
            labelText: hint,
            border: InputBorder.none),
        keyboardType:
            hint != 'Password' ? TextInputType.phone : TextInputType.text,
        validator: (value) => hint == 'Mobile No.'
            ? loginController.validateMobile(value!)
            : loginController.validatePassword(value!),
      ),
    );
  }
}
