import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/colors.dart';
import 'package:flutter_application_1/google_sign_in_provider.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: scaffoldColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Text(
                'Welcome',
                style:
                    TextStyle(color: textColor, fontSize: size.height * 0.04),
              ),
              SizedBox(
                height: size.height * 0.04,
              ),
              Text(
                'to',
                style:
                    TextStyle(color: textColor, fontSize: size.height * 0.03),
              ),
              SizedBox(
                height: size.height * 0.04,
              ),
              Text(
                'Digital Coffee',
                style:
                    TextStyle(color: textColor, fontSize: size.height * 0.07),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: ElevatedButton.icon(
              onPressed: () {
                final provider =
                    Provider.of<GoogleSignInProvider>(context, listen: false);

                provider.googleLogIn();
              },
              icon: FaIcon(
                FontAwesomeIcons.google,
                color: redColor,
              ),
              label: const Text('Sign In with Google'),
              style: ElevatedButton.styleFrom(
                primary: brownColor,
                onPrimary: whiteColor,
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
