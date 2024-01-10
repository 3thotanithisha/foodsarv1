import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodsarv01/resources/auth_methods.dart';
import 'package:foodsarv01/screen/auth/login_screen.dart';
import 'package:foodsarv01/screen/redirect_screen.dart';
import 'package:foodsarv01/utils/transport_nav_bar.dart';
import 'package:foodsarv01/widgets/textfiled.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  void signUp() async {
    String res = await Authmethods()
        .signup(email: email.text, password: password.text, name: name.text);
    if (res == "success") {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Account created successfully')));
        const Duration(milliseconds: 500);
        if (FirebaseAuth.instance.currentUser!.email
            .toString()
            .contains('@transport.com')) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const TNavBar()));
        } else {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const RedirectScreen()));
        }
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(res)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/background.jpg'),
                fit: BoxFit.cover)),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 24),
              child: Text(
                'Sign Up',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 54, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextInput(hint: 'Name', controller: name),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextInput(hint: 'Email', controller: email),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextInput(
                hint: 'Password',
                controller: password,
                isPassword: true,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 90),
              child: InkWell(
                onTap: () => signUp(),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(26, 0, 0, 0),
                      border: Border.all(
                        color: Colors.black,
                        width: 1,
                      )),
                  child: const Center(
                      child: Text(
                    'Sign up',
                    style: TextStyle(color: Colors.white),
                  )),
                ),
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Already have an account?",
                  style: TextStyle(color: Colors.white),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
                  },
                  child:
                      const Text("Login", style: TextStyle(color: Colors.blue)),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
