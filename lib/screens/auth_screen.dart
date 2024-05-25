import 'package:cloud_firestore/cloud_firestore.dart';

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
                "Welcome to PITBOWL!",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.primary, fontSize: 50),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                    labelText: _isSignIn ? 'Username' : "Create your username"),
                style: const TextStyle(color: Colors.white),

                // keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                    labelText: _isSignIn ? 'Password' : "Create your password"),
                style: const TextStyle(color: Colors.white),
                obscureText: true,
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
                      backgroundColor:
                          Theme.of(context).colorScheme.primaryContainer),
                  child: Text(
                    _isSignIn ? "Sign In" : "Sign Up",
                    style: TextStyle(
                        color:
                            Theme.of(context).colorScheme.onPrimaryContainer),
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
