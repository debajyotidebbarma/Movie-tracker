import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movie_tracker/screens/main_screen.dart';

import 'formInputDecor.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    Key? key,
    required GlobalKey<FormState> formKey,
    required TextEditingController emailTextController,
    required TextEditingController passwordTextController,
  })  : _formKey = formKey,
        _emailTextController = emailTextController,
        _passwordTextController = passwordTextController,
        super(key: key);

  final GlobalKey<FormState> _formKey;
  final TextEditingController _emailTextController;
  final TextEditingController _passwordTextController;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.all(15),
          child: TextFormField(
            validator: (value) {
              return value!.isEmpty ? 'Please add an Email' : null;
            },
            controller: _emailTextController,
            decoration: formInputDecoration(
                label: 'Enter Email', hintText: 'abcd@example.com'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15),
          child: TextFormField(
            validator: (value) {
              return value!.isEmpty ? 'Please Enter Password' : null;
            },
            controller: _passwordTextController,
            decoration:
                formInputDecoration(label: 'Enter Password', hintText: ''),
            obscureText: true,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        TextButton(
            style: TextButton.styleFrom(
              primary: Colors.white,
              padding: EdgeInsets.all(15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              backgroundColor: Colors.amber,
              textStyle: TextStyle(
                fontSize: 18,
              ),
            ),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: _emailTextController.text,
                    password: _passwordTextController.text).then((value) {
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context)=>MainScreenPage(),));
                    });
              }
            },
            child: Text('Sign In'))
      ]),
    );
  }
}
