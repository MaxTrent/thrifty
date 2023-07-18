import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/widgets.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    final _formKey = GlobalKey<FormState>();
    final _messengerKey = GlobalKey<ScaffoldMessengerState>();
    final _firstNameController = TextEditingController();
    final _lastNameController = TextEditingController();
    final _emailController = TextEditingController();
    final _passwordController = TextEditingController();
    bool _loading = false;
    bool _obscureText = true;
    String firstName = _firstNameController.text.toString();
    String lastName = _lastNameController.text.toString();
    String email = _emailController.text.toString();
    String pword = _passwordController.text.toString();


    void error(errorMessage) {
      _messengerKey.currentState!.showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red[600],
          elevation: 0,
          content: Text(
            errorMessage,
            textAlign: TextAlign.center,
          )));
    }

    Future<bool> sendToDB(firstname, lastname, email) async {
      User? user = auth.currentUser;
      if (user!.uid.isNotEmpty) {
        try {
          CollectionReference users = FirebaseFirestore.instance.collection(
              'users');
          await users.add({
            "firstname": firstname,
            "lastname": lastname,
            "email": email,
            "userId": user.uid,
            "amount": 0,
            "amountReset": 0,
            "lastResetTime": DateTime.now()
          }
          );
          return true;
        } catch (e) {
          return false;
        }
      }
      return false;
    }


    Future<bool> doesUserAlreadyExist(String uid) async {
      final dynamic values = await FirebaseFirestore.instance
          .collection("users")
          .where('userId', isEqualTo: uid)
          .limit(1)
          .get();

      if (values.size >= 1) {
        return true;
      } else {
        return false;
      }
    }

    Future<void> register(username, password) async {
      try {
        final credential = await auth.createUserWithEmailAndPassword(
            email: email, password: password).then((value) =>
            print('user with user id ${value.user!.uid} is logged in'));

        bool addData = await sendToDB(firstName, lastName, email);
        print('add data ${addData.toString()}');
        if (addData == true) {
          Navigator.pushReplacementNamed(context, '/homepage');
        }
        else {
          error('Error signing up');
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          error('Password is weak');
        }
        else if (e.code == 'email-already-in-use') {
          User? user = auth.currentUser;
          if (user!.uid.isNotEmpty) {
            bool userExist = await doesUserAlreadyExist(user.uid);
            if (userExist == true) {
              error('This account exists');
            }
            else {
              bool addData = await sendToDB(firstName, lastName, email);
              print('add data ${addData.toString()}');
              if (addData == true) {
                Navigator.pushReplacementNamed(context, '/homepage');
              } else {
                error('Error signing user up');
              }
            }
          } else {
            error('This account exists');
          }
        } else if (e.code == 'invalid-email') {
          error('Invalid Email');
        } else {
          error(e.message);
          if (kDebugMode) {
            print(e);
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }

      setState(() {
        _loading = false;
      });
    }


    return Stack(children: [
      Scaffold(
        body: SafeArea(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Form(
                    // key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10.0,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Sign Up',
                            textAlign: TextAlign.left,
                            style: Theme
                                .of(context)
                                .textTheme
                                .headline2,
                          ),
                        ),
                        const SizedBox(
                          height: 80.0,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Firstname',
                            style: Theme
                                .of(context)
                                .textTheme
                                .headline3!
                                .copyWith(color: Colors.grey),
                          ),
                        ),
                        const SizedBox(
                          height: 2.0,
                        ),
                        TextFormField(
                          controller: _firstNameController,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.person_outline),
                            border: OutlineInputBorder(),
                            hintText: 'Samuel',
                          ),
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.sentences,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(100),
                          ],
                          onFieldSubmitted: (value) {},
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Firstname is required';
                            }
                          },
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Lastname',
                            style: Theme
                                .of(context)
                                .textTheme
                                .headline3!
                                .copyWith(color: Colors.grey),
                          ),
                        ),
                        const SizedBox(
                          height: 2.0,
                        ),
                        TextFormField(
                          controller: _lastNameController,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.person_outline),
                            border: OutlineInputBorder(),
                            hintText: 'Doe',
                          ),
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.sentences,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onFieldSubmitted: (value) {},
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(100),
                          ],
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Lastname is required';
                            }
                          },
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Email',
                            style: Theme
                                .of(context)
                                .textTheme
                                .headline3!
                                .copyWith(color: Colors.grey),
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
                          keyboardType: TextInputType.emailAddress,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onFieldSubmitted: (value) {},
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(100),
                          ],
                          validator: (value) {
                            if (value!.isEmpty ||
                                !RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value)) {
                              return 'Enter a valid email';
                            }
                          },
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Password',
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .headline3!
                                  .copyWith(color: Colors.grey),
                            )),
                        const SizedBox(
                          height: 2.0,
                        ),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscureText,
                          decoration: InputDecoration(
                              prefixIcon: const Icon(CupertinoIcons.lock),
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
                            LengthLimitingTextInputFormatter(100),
                          ],
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value!.isEmpty || value.length < 6) {
                              return 'Password must be at least 6  character';
                            }
                          },
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        Text(
                          'Creating an account means you agree to the Terms of Service and our Privacy Policy',
                          textAlign: TextAlign.center,
                          style: Theme
                              .of(context)
                              .textTheme
                              .headline3!
                              .copyWith(color: Colors.grey),
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        ElevatedButton(
                            onPressed:
                            // Navigator.push(context, MaterialPageRoute(builder: (c)=> HomePage()));

                            !_loading
                                ? () {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  _loading = true;
                                });
                                register(email,
                                    pword);
                              }
                            }
                                : null,
                            child: Text(
                              'Create Account',
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .headline1,
                            )),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account ?",
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .headline3,
                            ),
                            TextButton(
                                style: TextButton.styleFrom(
                                    primary: const Color.fromARGB(
                                        255, 4, 44, 76)),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Sign in',
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .headline3,
                                )),
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            )),
      ),
      if (_loading) const Center(child: LoadingIndicator())
    ]);
  }

}


