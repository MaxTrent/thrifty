import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:thrifty/screens/screens.dart';
import 'package:thrifty/widgets/widgets.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _emailController = TextEditingController();
    final _passwordController = TextEditingController();
    bool _obscureText = true;

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
                                  // LengthLimitingTextInputFormatter(50),
                                ],
                                keyboardType: TextInputType.emailAddress,
                                autovalidateMode:
                                AutovalidateMode.onUserInteraction,
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
                                  child: Text(
                                    'Password',
                                    style: Theme.of(context).textTheme.headline3),),
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
                                          // setState(() {
                                          //   _obscureText = !_obscureText;
                                          // });
                                        },
                                        icon: Icon(
                                            // _obscureText
                                            // ? Icons.visibility:
                                          Icons.visibility_off)),
                                    border: const OutlineInputBorder(),
                                    hintText: '*******'),
                                inputFormatters: [
                                  // LengthLimitingTextInputFormatter(50),
                                ],
                                autovalidateMode:
                                AutovalidateMode.onUserInteraction,
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

                                  onPressed:
                                  (){},
                                  // !_loading
                                  //     ? () {
                                  //   if (_formKey.currentState!.validate()) {
                                  //     setState(() {
                                  //       _loading = true;
                                  //     });
                                  //
                                  //     login(
                                  //         _emailController.text.toString(),
                                  //         _passwordController.text
                                  //             .toString());
                                  //   }
                                  // }
                                  //     : null,
                                  child: Text('Sign in',
                                  style: Theme.of(context).textTheme.headline1,)
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Dont have an account ?",
                                  style: Theme.of(context).textTheme.headline3,),
                                  TextButton(
                                      style: TextButton.styleFrom(
                                          // primary: Color.fromARGB(255, 4, 44, 76)
    ),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: ((context) =>
                                                const SignUpScreen())));
                                      },
                                      child: Text('Sign up',
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
          // if (_loading)
            const Center(
              child: LoadingIndicator()
            )
        ],
    );
  }
}
