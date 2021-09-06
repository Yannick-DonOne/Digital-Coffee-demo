import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/album_details.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/colors.dart';
import 'package:flutter_application_1/google_sign_in_provider.dart';
import 'package:flutter_application_1/home_screen.dart';

String firstAuthor = '';
String secontAuthor = '';
String thirdAuthor = '';

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    String? name = user!.displayName;

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: scaffoldColor,
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 0.0, top: 20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello ' + name!,
                        style: TextStyle(
                            fontSize: size.width * 0.06,
                            color: textColor,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: size.width * 0.03,
                      ),
                      Text(
                        'Find The Best Content Here Daily',
                        style: TextStyle(
                            fontSize: size.width * 0.03,
                            color: subTextColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  IconButton(
                      onPressed: () {
                        final provider = Provider.of<GoogleSignInProvider>(
                            context,
                            listen: false);
                        provider.logOut();
                      },
                      icon: Icon(
                        Icons.logout,
                        color: brownColor,
                      ))
                ],
              ),
            ),
            SizedBox(
              width: size.width,
              height: size.height * 0.25,
              child: _banner(context),
            ),
            Container(
              padding:
                  const EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
              width: size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                    child: Text(
                      'Popular Authors',
                      style: TextStyle(
                        fontSize: size.width * 0.05,
                        color: textColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // size.height * 0.3
                  SizedBox(
                    height: size.height * 0.3,
                    width: size.width,
                    child: _authorOne(context),
                  ),
                  SizedBox(
                    height: size.height * 0.3,
                    width: size.width,
                    child: _authorTwo(context),
                  ),
                  SizedBox(
                    height: size.height * 0.3,
                    width: size.width,
                    child: _authorThree(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _banner(context) {
    Size size = MediaQuery.of(context).size;
    int len = 0;

    return StreamBuilder<QuerySnapshot<Map>>(
        stream: authors,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Something Went Wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              color: textColor,
            ));
          }
          final data = snapshot.data;
          if (data!.docs.length < 10) {
            len = data.docs.length;
          } else {
            len = 10;
          }

          return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: len,
              itemBuilder: (context, index) {
                final episodes = FirebaseFirestore.instance
                    .collection('Authors')
                    .doc(data.docs[index].id)
                    .collection('episodes')
                    .snapshots();
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AlbumDetails(
                          albumData: data.docs[index],
                          episodes: episodes,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.only(left: 10.0, top: 10.0),
                    child: Container(
                      height: size.height * 0.25,
                      width: size.width * 0.9,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(size.width * 0.05),
                        ),
                        image: DecorationImage(
                          image: NetworkImage(data.docs[index]['albumImage']),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 13.0, bottom: 10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: size.height * 0.05,
                                ),
                                SizedBox(
                                  width: size.width * 0.64,
                                  child: Text(
                                    data.docs[index]['genre'],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                    style: TextStyle(
                                      color: whiteColor,
                                      fontSize: size.width * 0.035,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: size.width * 0.64,
                                  child: Text(
                                    data.docs[index]['title'],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                    style: TextStyle(
                                      color: whiteColor,
                                      fontSize: size.width * 0.085,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: size.width * 0.64,
                                  child: Text(
                                    'with ' + data.docs[index]['author'],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                    style: TextStyle(
                                      color: whiteColor,
                                      fontSize: size.width * 0.035,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(bottom: 30, right: 13.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: whiteColor,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(50.0),
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.play_arrow,
                                    color: blackColor,
                                    size: size.width * 0.07,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              });
        });
  }

  _authorOne(context) {
    Size size = MediaQuery.of(context).size;
    int len = 0;

    return StreamBuilder<QuerySnapshot<Map>>(
        stream: authors,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Something Went Wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              color: textColor,
            ));
          }
          final data = snapshot.data;
          if (data!.docs.length < 10) {
            len = data.docs.length;
          } else {
            len = 10;
          }
          firstAuthor = data.docs[0]['author'];

          return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: len,
              itemBuilder: (context, index) {
                final episodes = FirebaseFirestore.instance
                    .collection('Authors')
                    .doc(data.docs[index].id)
                    .collection('episodes')
                    .snapshots();
                if (data.docs[index]['author'] == firstAuthor) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AlbumDetails(
                            albumData: data.docs[index],
                            episodes: episodes,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.only(left: 10.0, top: 10.0),
                      child: Container(
                        height: size.height * 0.3,
                        width: size.width * 0.4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(size.width * 0.05),
                          ),
                          image: DecorationImage(
                            image: NetworkImage(data.docs[index]['albumImage']),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 10.0, bottom: 10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: size.height * 0.05,
                              ),
                              Text(
                                data.docs[index]['genre'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                style: TextStyle(
                                  color: whiteColor,
                                  fontSize: size.width * 0.035,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                data.docs[index]['title'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                style: TextStyle(
                                  color: whiteColor,
                                  fontSize: size.width * 0.09,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'with ' + data.docs[index]['author'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                style: TextStyle(
                                  color: whiteColor,
                                  fontSize: size.width * 0.035,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              });
        });
  }

  _authorTwo(context) {
    Size size = MediaQuery.of(context).size;
    int len = 0;

    return StreamBuilder<QuerySnapshot<Map>>(
        stream: authors,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Something Went Wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              color: textColor,
            ));
          }
          final data = snapshot.data;
          if (data!.docs.length < 10) {
            len = data.docs.length;
          } else {
            len = 10;
          }

          for (int i = 1; i < len; i++) {
            secontAuthor = data.docs[i]['author'];
            if (secontAuthor == firstAuthor) {
              continue;
            } else {
              break;
            }
          }
          return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: len,
              itemBuilder: (context, index) {
                final episodes = FirebaseFirestore.instance
                    .collection('Authors')
                    .doc(data.docs[index].id)
                    .collection('episodes')
                    .snapshots();
                if (data.docs[index]['author'] == secontAuthor) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AlbumDetails(
                            albumData: data.docs[index],
                            episodes: episodes,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.only(left: 10.0, top: 10.0),
                      child: Container(
                        height: size.height * 0.3,
                        width: size.width * 0.4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(size.width * 0.05),
                          ),
                          image: DecorationImage(
                            image: NetworkImage(data.docs[index]['albumImage']),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 10.0, bottom: 10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: size.height * 0.05,
                              ),
                              Text(
                                data.docs[index]['genre'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                style: TextStyle(
                                  color: whiteColor,
                                  fontSize: size.width * 0.035,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                data.docs[index]['title'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                style: TextStyle(
                                  color: whiteColor,
                                  fontSize: size.width * 0.09,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'with ' + data.docs[index]['author'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                style: TextStyle(
                                  color: whiteColor,
                                  fontSize: size.width * 0.035,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              });
        });
  }

  _authorThree(context) {
    Size size = MediaQuery.of(context).size;
    int len = 0;

    return StreamBuilder<QuerySnapshot<Map>>(
        stream: authors,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Something Went Wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              color: textColor,
            ));
          }
          final data = snapshot.data;
          if (data!.docs.length < 10) {
            len = data.docs.length;
          } else {
            len = 10;
          }
          for (int i = 2; i < len; i++) {
            thirdAuthor = data.docs[i]['author'];
            if (thirdAuthor == firstAuthor || thirdAuthor == secontAuthor) {
              thirdAuthor = '';
              continue;
            } else {
              break;
            }
          }

          return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: len,
              itemBuilder: (context, index) {
                final episodes = FirebaseFirestore.instance
                    .collection('Authors')
                    .doc(data.docs[index].id)
                    .collection('episodes')
                    .snapshots();
                if (data.docs[index]['author'] == thirdAuthor) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AlbumDetails(
                            albumData: data.docs[index],
                            episodes: episodes,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.only(left: 10.0, top: 10.0),
                      child: Container(
                        height: size.height * 0.3,
                        width: size.width * 0.4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(size.width * 0.05),
                          ),
                          image: DecorationImage(
                            image: NetworkImage(data.docs[index]['albumImage']),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 10.0, bottom: 10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: size.height * 0.05,
                              ),
                              Text(
                                data.docs[index]['genre'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                style: TextStyle(
                                  color: whiteColor,
                                  fontSize: size.width * 0.035,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                data.docs[index]['title'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                style: TextStyle(
                                  color: whiteColor,
                                  fontSize: size.width * 0.09,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'with ' + data.docs[index]['author'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                style: TextStyle(
                                  color: whiteColor,
                                  fontSize: size.width * 0.035,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              });
        });
  }
}
