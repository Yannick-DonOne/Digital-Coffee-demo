import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/audio_details.dart';
import 'package:flutter_application_1/colors.dart';

class Playlist extends StatelessWidget {
  List<QueryDocumentSnapshot<Map>> episodesData;
  AudioPlayer prebiousAudioPlayer;
  QueryDocumentSnapshot<Map?> albumData;
  Playlist(
      {Key? key,
      required this.episodesData,
      required this.prebiousAudioPlayer,
      required this.albumData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: scaffoldColor,
      body: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: episodesData.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => AudioDetails(
                    albumData: albumData,
                    episodesData: episodesData,
                    index: index,
                    max: episodesData.length,
                    prebiousAudioPlayer: prebiousAudioPlayer,
                    key: UniqueKey(),
                  ),
                ),
              );
            },
            child: Container(
              height: size.height * 0.09,
              margin: const EdgeInsets.only(top: 8.0),
              decoration: BoxDecoration(
                border:
                    Border.all(color: blackColor.withOpacity(0.3), width: 1),
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
      ),
    );
  }
}
