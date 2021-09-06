import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/album_details.dart';
import 'package:flutter_application_1/colors.dart';
import 'package:flutter_application_1/home_screen.dart';

class Categories extends StatelessWidget {
  const Categories({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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

          return Scaffold(
            appBar: AppBar(
              title: const Text('Albums'),
              backgroundColor: brownColor,
            ),
            backgroundColor: scaffoldColor,
            body: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: data!.docs.length,
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
                      padding: const EdgeInsets.only(
                          left: 10.0, top: 10.0, right: 10.0),
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
                              padding: const EdgeInsets.only(
                                  left: 13.0, bottom: 10.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
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
                              padding: const EdgeInsets.only(
                                  bottom: 30, right: 13.0),
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
                }),
          );
        });
  }
}
