import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/audio_details.dart';
import 'package:flutter_application_1/colors.dart';
import 'package:flutter_application_1/playlist.dart';

class AlbumDetails extends StatelessWidget {
  final Stream<QuerySnapshot<Map>>? episodes;
  final QueryDocumentSnapshot<Map?> albumData;

  const AlbumDetails(
      {Key? key, required this.episodes, required this.albumData})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return StreamBuilder<QuerySnapshot<Map>>(
        stream: episodes,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Something Went Wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: textColor));
          }
          final data = snapshot.data;

          return Scaffold(
            backgroundColor: scaffoldColor,
            body: SafeArea(
              child: Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        height: size.height * 0.25,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(albumData['albumImage']),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Container(
                          height: size.height * 0.25,
                          width: size.width,
                          color: blackColor.withOpacity(0.3),
                        ),
                      ),
                      Expanded(child: Container())
                    ],
                  ),
                  Container(
                    height: size.height,
                    width: size.width,
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: size.height * 0.03,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: whiteColor.withOpacity(0.1),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(size.width * 0.05),
                                ),
                              ),
                              child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Icon(
                                  Icons.arrow_back,
                                  color: whiteColor,
                                  size: size.height * 0.03,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: whiteColor.withOpacity(0.1),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(size.width * 0.05),
                                ),
                              ),
                              child: Icon(
                                Icons.more_vert,
                                color: whiteColor,
                                size: size.height * 0.03,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: size.height * 0.06,
                        ),
                        Center(
                          child: Column(
                            children: [
                              SizedBox(
                                height: size.height * 0.12,
                              ),
                              Text(
                                albumData['title'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: size.width * 0.07,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.005,
                              ),
                              Text(
                                albumData['author'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: size.width * 0.04,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.008,
                              ),
                              Text(
                                albumData['description'],
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: subTextColor,
                                  fontSize: size.width * 0.03,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: size.height * 0.01,
                              ),
                              Text(
                                '20'
                                        ' '
                                        'Followers '
                                        '* ' +
                                    data!.size.toString() +
                                    ' '
                                        'Episodes',
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: size.width * 0.04,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.015,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              Icons.bookmark_border,
                              color: textColor,
                              size: size.width * 0.08,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(size.width * 0.06),
                                ),
                                color: Colors.purple,
                              ),
                              height: size.height * 0.06,
                              width: size.width * 0.4,
                              child: Center(
                                child: Text(
                                  'Follow',
                                  style: TextStyle(
                                    color: whiteColor,
                                    fontSize: size.width * 0.05,
                                  ),
                                ),
                              ),
                            ),
                            Icon(
                              Icons.share,
                              color: textColor,
                              size: size.width * 0.08,
                            )
                          ],
                        ),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Episodes',
                              style: TextStyle(
                                fontSize: size.width * 0.05,
                                color: textColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: const [
                                Icon(Icons.search),
                              ],
                            )
                          ],
                        ),
                        Expanded(
                            child: Playlist(
                          albumData: albumData,
                          episodesData: data.docs,
                          prebiousAudioPlayer: AudioPlayer(),
                          key: UniqueKey(),
                        ))
                        // _episodes(context, data.docs),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  _episodes(context, List<QueryDocumentSnapshot<Map>> episodesData) {
    //albumId
    Size size = MediaQuery.of(context).size;
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: episodesData.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AudioDetails(
                  albumData: albumData,
                  episodesData: episodesData,
                  index: index,
                  max: episodesData.length,
                  prebiousAudioPlayer: AudioPlayer(),
                  key: UniqueKey(),
                ),
              ),
            );
          },
          child: Container(
            height: size.height * 0.09,
            margin: const EdgeInsets.only(top: 8.0),
            decoration: BoxDecoration(
              border: Border.all(color: blackColor.withOpacity(0.3), width: 1),
              borderRadius: BorderRadius.all(
                Radius.circular(size.width * 0.05),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: size.width * 0.13,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Ep',
                        style: TextStyle(
                          color: subTextColor,
                          fontSize: size.width * 0.05,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        (index + 1).toString(),
                        style: TextStyle(
                          color: subTextColor,
                          fontSize: size.width * 0.05,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: size.width * 0.6,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        episodesData[index]['episodeTitle'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        style: TextStyle(
                          color: textColor,
                          fontSize: size.width * 0.04,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.003,
                      ),
                      Text(
                        '20'
                        ' Minuits '
                        '* '
                        '20'
                        ' '
                        '20'
                        ' '
                        '20',
                        style: TextStyle(
                          color: subTextColor,
                          fontSize: size.width * 0.035,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: size.width * 0.15,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(size.width * 0.1),
                        ),
                        color: subTextColor.withOpacity(0.5),
                      ),
                      child: Icon(
                        Icons.play_arrow,
                        size: size.width * 0.1,
                        color: Colors.purple,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
