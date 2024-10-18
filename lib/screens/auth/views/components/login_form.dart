import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop/models/login_model.dart';
import 'package:shop/route/route_constants.dart';
import 'package:shop/services/login_service.dart';
import '../../../../constants.dart';

class LogInForm extends StatefulWidget {
  const LogInForm({
    super.key,
    required this.formKey,
  });

  final GlobalKey<FormState> formKey;

  @override
  _LogInFormState createState() => _LogInFormState();
}

class _LogInFormState extends State<LogInForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final String _platformController = 'MOBILE';
  final String _versionController = '1.0.0';
  String _loginResult = '';

  void _login() async {
    if (widget.formKey.currentState!.validate()) {
      final loginService = LoginService();
      final loginModel = LoginModel(
        username: _usernameController.text,
        password: _passwordController.text,
        platform: _platformController,
        version: _versionController,
      );

      try {
        final result = await loginService.login(
          loginModel.username,
          loginModel.password,
          loginModel.platform,
          loginModel.version,
         
        );
        setState(() {
          _loginResult = 'Login success!';
           Navigator.pushReplacementNamed(context, entryPointScreenRoute);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _loginResult,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: primaryColor,
          ),
        );
      } catch (e) {
        setState(() {
          _loginResult = 'Usernam or password is incorrect!';
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _loginResult,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: const Color.fromARGB(255, 246, 245, 245),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _usernameController,
            decoration: const InputDecoration(labelText: 'User Name'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a username';
              }
              if (value.length < 6) {
                return 'Username must be at least 6 characters long';
              }
              if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
                return 'Username can only contain letters and numbers';
              }
              return null;
            },
          ),
          const Padding(
            padding: EdgeInsets.only(top: defaultPadding),
          ),
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a password';
              }
              if (value.length < 8) {
                return 'Password must be at least 8 characters long';
              }
              return null;
            },
          ),
          const Padding(
            padding: EdgeInsets.only(top: defaultPadding),
          ),
          ElevatedButton(
            onPressed: _login,
            child: const Text('Login'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Don't have an account?"),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, signUpScreenRoute);
                },
                child: const Text("Sign up"),
              )
            ],
          ),
        ],
      ),
    );
  }
}