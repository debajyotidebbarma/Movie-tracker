import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movie_tracker/screens/main_screen.dart';
import 'package:movie_tracker/services/create_user.dart';

import 'formInputDecor.dart';

class CreateAccountForm extends StatelessWidget {
  const CreateAccountForm({
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
        Text(
            'Please enter a valid email and a password that is atleast 6 characters'),
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
              // print('hello');
              if (_formKey.currentState!.validate()) {
                String email = _emailTextController.text;
                FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                        email: email, password: _passwordTextController.text)
                    .then((value) {
                  if (value.user != null) {
                    String displayName = email.toString().split('@')[0];
                    createUser(displayName, context).then((value) {
                      FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                              email: _emailTextController.text,
                              password: _passwordTextController.text)
                          .then((value) {
                        return Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MainScreenPage(),
                            ));
                      });
                    });
                  }
                });
              }
            },
            child: Text('Create Account'))
      ]),
    );
  }
}

