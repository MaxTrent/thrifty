import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../pages/pages.dart';
import '../widgets/widgets.dart';


class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                              style: Theme.of(context).textTheme.headline2,
                            ),
                          ),
                          const SizedBox(
                            height: 80.0,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Firstname',
                              style: Theme.of(context).textTheme.headline3!.copyWith(color: Colors.grey),
                            ),
                          ),
                          const SizedBox(
                            height: 2.0,
                          ),
                          TextFormField(
                            // controller: _firstNameController,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.person_outline),
                              border: OutlineInputBorder(),
                              hintText: 'John',
                            ),
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.sentences,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            inputFormatters: [
                              // LengthLimitingTextInputFormatter(100),
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
                              style: Theme.of(context).textTheme.headline3!.copyWith(color: Colors.grey),
                            ),
                          ),
                          const SizedBox(
                            height: 2.0,
                          ),
                          TextFormField(
                            // controller: _lastNameController,
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
                              // LengthLimitingTextInputFormatter(100),
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
                              style: Theme.of(context).textTheme.headline3!.copyWith(color: Colors.grey),
                            ),
                          ),
                          const SizedBox(
                            height: 2.0,
                          ),
                          TextFormField(
                            // controller: _emailController,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.mail_outline),
                              border: OutlineInputBorder(),
                              hintText: 'test@gmail.com',
                            ),
                            keyboardType: TextInputType.emailAddress,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            onFieldSubmitted: (value) {},
                            inputFormatters: [
                              // LengthLimitingTextInputFormatter(100),
                            ],
                            validator: (value) {
                              if (value!.isEmpty ||
                                  !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
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
                                style: Theme.of(context).textTheme.headline3!.copyWith(color: Colors.grey),
                              )),
                          const SizedBox(
                            height: 2.0,
                          ),
                          TextFormField(
                            // controller: _passwordController,
                            // obscureText: _obscureText,
                            decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.password),
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      // setState(() {
                                      //   _obscureText = !_obscureText;
                                      // });
                                    },
                                    icon: Icon(
                                        // _obscureText
                                        // ? Icons.visibility
                                        // :
                                        Icons.visibility_off)),
                                border: const OutlineInputBorder(),
                                hintText: '*******'),
                            inputFormatters: [
                              // LengthLimitingTextInputFormatter(100),
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
                            style: Theme.of(context).textTheme.headline3!.copyWith(color: Colors.grey),
                          ),
                          const SizedBox(
                            height: 25.0,
                          ),
                          ElevatedButton(
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (c)=> HomePage()));
                              },
                              // !_loading
                              //     ? () {
                              //   if (_formKey.currentState!.validate()) {
                              //     setState(() {
                              //       _loading = true;
                              //     });
                              //     register(_emailController.text.toString(),
                              //         _passwordController.text.toString());
                              //   }
                              // }
                              //     : null,
                              child: Text('Create Account',
                              style: Theme.of(context).textTheme.headline1,)),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Already have an account ?",
                                style: Theme.of(context).textTheme.headline3,
                              ),
                              TextButton(
                                  style: TextButton.styleFrom(
                                      primary: Color.fromARGB(255, 4, 44, 76)),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child:  Text('Sign in',
                                  style: Theme.of(context).textTheme.headline3,)),
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              )),
        ),
        // if (_loading)
        const Center(
            child: LoadingIndicator()
        )
      ]);
  }
}
