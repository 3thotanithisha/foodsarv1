import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodsarv01/screen/auth/signup_screen.dart';
import 'package:foodsarv01/utils/navbar.dart';

class RedirectScreen extends StatelessWidget {
  const RedirectScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.all(2),
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(48, 48, 92, 1),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              const Text('FoodSavr',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 40,
              ),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const NavBar(
                                      isDonate: true,
                                    )));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: const Color.fromRGBO(61, 63, 106, 1),
                        ),
                        height: 160,
                        child: const Center(
                            child: Text(
                          'Donate Food',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        )),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                      child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const NavBar(
                                    isDonate: false,
                                  )));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: const Color.fromRGBO(61, 63, 106, 1),
                      ),
                      height: 160,
                      child: const Center(
                          child: Text(
                        'Get Food',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      )),
                    ),
                  ))
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              InkWell(
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignUpScreen()));
                },
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: const Color.fromRGBO(61, 63, 106, 1),
                      ),
                      height: 160,
                      child: const Center(
                          child: Text(
                        'Logout',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      )),
                    )),
                  ],
                ),
              ),
              const Spacer(
                flex: 2,
              )
            ],
          ),
        ),
      ),
    );
  }
}
