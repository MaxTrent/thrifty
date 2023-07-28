import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:thrifty/screens/screens.dart';
import 'package:thrifty/widgets/widgets.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _loading = false;
  bool _obscureText = true;
  FirebaseAuth auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkIfSignedIn();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void checkIfSignedIn() {
    User? user = auth.currentUser;

    if (user != null && user.uid.isEmpty) {
      print('Signed In');
    } else {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/homepage');
      });
    }
  }

  Future<void> signIn(email, password) async {
    try {
      final credential = await auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then(
              (value) => Navigator.pushReplacementNamed(context, '/homepage'));
      User? user = auth.currentUser;
      var id = user!.uid;
      if (kDebugMode) {
        print('User with $id is signed in');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' ||
          e.code == 'wrong-password' ||
          e.code == 'invalid-email') {
        error('Wrong email or password.');
        if (kDebugMode) {
          print('No user found');
        }
      } else if (e.code == 'too-many-requests') {
        error(
            'Account has been temporarily disabled due to too many failed attempts');
      } else {
        error(e.message);
        if (kDebugMode) {
          print(e);
        }
      }
    } catch (e) {
      error(e);
      if (kDebugMode) {
        print(e);
      }
    }
    setState(() {
      _loading = false;
    });
  }

  error(errorMessage) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            width: MediaQuery.of(context).size.width,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red[600],
            elevation: 0,
            content: Text(
              errorMessage,
              textAlign: TextAlign.center,
            ),
          ),
        );
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(

      children: [
        Scaffold(
          body: Center(
            child: SafeArea(
                child: ListView(
              shrinkWrap: true,
              children: [
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Center(
                          child: Text(
                            'Welcome Back',
                            style: Theme.of(context).textTheme.headline2,
                          ),
                        ),
                        const SizedBox(
                          height: 50.0,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Email',
                            style: Theme.of(context).textTheme.headline3,
                          ),
                        ),
                        const SizedBox(
                          height: 2.0,
                        ),
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.mail_outline),
                            border: OutlineInputBorder(),
                            hintText: 'test@gmail.com',
                          ),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(50),
                          ],
                          keyboardType: TextInputType.emailAddress,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onFieldSubmitted: (value) {},
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Email is required';
                            }
                          },
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Password',
                              style: Theme.of(context).textTheme.headline3),
                        ),
                        const SizedBox(
                          height: 2.0,
                        ),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscureText,
                          decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.password),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _obscureText = !_obscureText;
                                    });
                                  },
                                  icon: Icon(_obscureText
                                      ? Icons.visibility
                                      : Icons.visibility_off)),
                              border: const OutlineInputBorder(),
                              hintText: '*******'),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(50),
                          ],
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Password is required';
                            }
                          },
                        ),
                        const SizedBox(
                          height: 35.0,
                        ),
                        ElevatedButton(
                            onPressed: !_loading
                                ? () {
                                    if (_formKey.currentState!.validate()) {
                                      setState(() {
                                        _loading = true;
                                      });
                                      signIn(_emailController.text.toString(),
                                          _passwordController.text.toString());
                                    }
                                  }
                                : null,
                            child: Text(
                              'Sign in',
                              style: Theme.of(context).textTheme.headline1!.copyWith(color: Theme.of(context).colorScheme.primary),
                            )),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Dont have an account ?",
                              style: Theme.of(context).textTheme.headline3,
                            ),
                            TextButton(
                                // style: TextButton.styleFrom(
                                //     // primary: Color.fromARGB(255, 4, 44, 76)
                                //     ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: ((context) =>
                                              const SignUpScreen())));
                                },
                                child: Text(
                                  'Sign up',
                                  style: Theme.of(context).textTheme.headline3,
                                ))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            )),
          ),
        ),
        if (_loading) const Center(child: LoadingIndicator())
      ],
    );
  }
}
