import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firebaseAuth = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isSignIn = true;
  bool _isAuthenticating = false;

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  void _submit() async {
    final email = _emailController.text.trim();
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || _usernameController.text.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Please enter your email, username and password',
            style: TextStyle(
                color: Colors.white,
                // fontWeight: FontWeight.normal,
                fontSize: 15),
            textAlign: TextAlign.left,
          ),
          backgroundColor: Theme.of(context).colorScheme.onError,
          dismissDirection: DismissDirection.horizontal,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(7),
            ),
          ),
        ),
      );
      return;
    }

    FocusScope.of(context).unfocus();

    UserCredential userCredential;

    try {
      setState(() {
        _isAuthenticating = true;
      });
      if (_isSignIn) {
        userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({'email': email, 'username': username});
      }
    } on FirebaseAuthException catch (e) {
      var message = 'An error occurred, please check your credentials!';

      //? might need to check this error exception name
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'The account already exists for that email.';
      } else if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided for that user.';
      }

      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: const TextStyle(
                color: Colors.white,
                // fontWeight: FontWeight.bold,
                fontSize: 15),
            textAlign: TextAlign.left,
          ),
          backgroundColor: Theme.of(context).colorScheme.onError,
          dismissDirection: DismissDirection.horizontal,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(7),
            ),
          ),
        ),
      );
    } catch (e) {
      print(e);
    }

    print(
        "Successfully authenticated $username with email $email and password $password");
    setState(() {
      _isAuthenticating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(_isSignIn ? 'Sign In' : 'Sign Up'),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                // "Welcome to PITBOWL!",
                "PITBOWL",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.primary, fontSize: 50),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isSignIn ? "Email" : "Your email",
                      style: const TextStyle(
                          color: Color.fromARGB(255, 232, 235, 236),
                          fontSize: 15),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(
                              color: Color.fromARGB(255, 230, 248, 248)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary),
                        ),
                      ),
                      style: const TextStyle(
                          color: Color.fromARGB(255, 216, 216, 216)),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isSignIn ? "Username" : "Your username",
                      style: const TextStyle(
                          color: Color.fromARGB(255, 232, 235, 236),
                          fontSize: 15),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(
                              color: Color.fromARGB(255, 230, 248, 248)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary),
                        ),
                      ),
                      style: const TextStyle(
                          color: Color.fromARGB(255, 216, 216, 216)),

                      // keyboardType: TextInputType.emailAddress,
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isSignIn ? "Password" : "Your password",
                      style: const TextStyle(
                          color: Color.fromARGB(255, 232, 235, 236),
                          fontSize: 15),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(
                              color: Color.fromARGB(255, 230, 248, 248)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary),
                        ),
                      ),
                      style: const TextStyle(
                          color: Color.fromARGB(255, 216, 216, 216)),
                      obscureText: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              if (_isAuthenticating) const CircularProgressIndicator(),
              if (!_isAuthenticating)
                ElevatedButton(
                  onPressed: () {
                    _submit();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary),
                  child: Text(
                    _isSignIn ? "Sign In" : "Sign Up",
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              if (!_isAuthenticating)
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isSignIn = !_isSignIn;
                      // _isSignInMode = _isSignInMode ? false : true;
                    });
                  },
                  child: Text(_isSignIn
                      ? "Create an account"
                      : "I already have an account"),
                )
            ]),
      ),
    );
  }
}
