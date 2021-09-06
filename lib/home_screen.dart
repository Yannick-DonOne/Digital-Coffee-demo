import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/build_history.dart';
import 'package:flutter_application_1/categories.dart';
import 'package:flutter_application_1/colors.dart';
import 'package:flutter_application_1/homepage.dart';
import 'package:flutter_application_1/login.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: textColor,
              ),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Something Went Wrong'),
            );
          } else if (snapshot.hasData) {
            return const HomeScreen();
          } else {
            return const Login();
          }
        },
      ),
    );
  }
}

final Stream<QuerySnapshot<Map>> authors =
    FirebaseFirestore.instance.collection('Authors').snapshots();

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<int> _pageNOtifier = ValueNotifier(0);
    Size size = MediaQuery.of(context).size;
    List<Widget> _pages = [
      SizedBox(
        height: size.height,
        width: size.width,
        child: MyHomePage(
          key: UniqueKey(),
        ),
      ),
      SizedBox(
        height: size.height,
        width: size.width,
        child: Categories(
          key: UniqueKey(),
        ),
      ),
      Container(
        color: Colors.yellow,
        height: size.height,
        width: size.width,
        child: BuildHistory(
          key: UniqueKey(),
        ),
      ),
    ];
    return ValueListenableBuilder<int>(
        valueListenable: _pageNOtifier,
        builder: (context, bool, _) {
          return Scaffold(
            bottomNavigationBar: Container(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
              color: brownColor,
              alignment: Alignment.center,
              height: size.height * 0.1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      _pageNOtifier.value = 0;
                      print(_pageNOtifier.value);
                    },
                    child: _navBarItem(
                      icon: Icons.home,
                      title: 'Home',
                    ),
                  ),
                  const SizedBox(
                    width: 5.0,
                  ),
                  InkWell(
                    onTap: () {
                      _pageNOtifier.value = 1;
                    },
                    child: _navBarItem(
                      icon: Icons.category,
                      title: 'Categories',
                    ),
                  ),
                  const SizedBox(
                    width: 5.0,
                  ),
                  InkWell(
                    onTap: () {
                      _pageNOtifier.value = 2;
                    },
                    child: _navBarItem(
                      icon: Icons.history,
                      title: 'History',
                    ),
                  ),
                ],
              ),
            ),
            body: _pages[_pageNOtifier.value],
          );
        });
  }
}

Widget _navBarItem({required String title, required IconData icon}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(icon, color: whiteColor),
      Text(
        title,
        style: TextStyle(color: whiteColor),
      ),
    ],
  );
}
