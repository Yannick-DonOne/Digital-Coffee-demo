import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/colors.dart';
import 'package:flutter_application_1/dats_model.dart';
import 'package:flutter_application_1/playlist.dart';
import 'groups.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
// import 'package:flutter_application_1/play_audio.dart';

class AudioDetails extends StatefulWidget {
  List<QueryDocumentSnapshot<Map>> episodesData;
  int index;
  int max;
  AudioPlayer prebiousAudioPlayer;
  QueryDocumentSnapshot<Map?> albumData;

  AudioDetails(
      {Key? key,
      required this.episodesData,
      required this.index,
      required this.max,
      required this.prebiousAudioPlayer,
      required this.albumData})
      : super(key: key);

  @override
  State<AudioDetails> createState() => _AudioDetailsState();
}

class _AudioDetailsState extends State<AudioDetails> {
  String status = '';
  ValueNotifier<int>? currentIndex;
  Map? episode;

  Duration _duration = const Duration(); //update to value Notifier
  Duration _position = const Duration(); //update to value Notifier
  // String path =
  //     "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3";
  bool isPlaying = false; //update to value Notifier
  bool isPaused = false;
  bool isLoop = false;
  final List<IconData> _icons = [Icons.play_arrow, Icons.pause];
  AudioPlayer advancedAudioPlayer = AudioPlayer();
  String audio = '';
  var fetchedFile;
  var cachedFile;
  @override
  void initState() {
    super.initState();
    currentIndex = ValueNotifier(widget.index);

    widget.prebiousAudioPlayer.pause();
    if (currentIndex != null && currentIndex!.value < widget.max) {
      episode = widget.episodesData[currentIndex!.value].data();
    }
    Repo.history.add(DataModel(widget.episodesData, widget.index, widget.max));

    if (Repo.history.length > 50) {
      Repo.history.removeLast();
    }

    advancedAudioPlayer.onDurationChanged.listen((event) {
      setState(() {
        _duration = event;
      });
    });
    advancedAudioPlayer.onAudioPositionChanged.listen((event) {
      setState(() {
        _position = event;
      });
    });
    audio = episode?['audio'];
    advancedAudioPlayer.setUrl(audio);
    advancedAudioPlayer.onPlayerCompletion.listen((event) {
      setState(() {
        _position = const Duration(seconds: 0);
        isPlaying = false;
      });
    });
  }

  @override
  void dispose() {
    advancedAudioPlayer.dispose();
    super.dispose();
  }

  Widget btnStart(Size size) {
    return GestureDetector(
      onTap: () async {
        if (isPlaying == false) {
          setState(() {
            status = 'Loading';
          });
          fetchedFile =
              await DefaultCacheManager().getSingleFile(audio, key: audio);
          cachedFile = await DefaultCacheManager().getFileFromCache(audio);

          setState(() {
            isPlaying = true;
            status = '';
          });
          advancedAudioPlayer.play(cachedFile.originalUrl);
        } else if (isPlaying == true) {
          advancedAudioPlayer.pause();
          setState(() {
            isPlaying = false;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(size.width * 0.1),
            ),
            color: subTextColor.withOpacity(0.4)),
        child: (isPlaying == false)
            ? Icon(
                _icons[0],
                size: size.width * 0.1,
                color: Colors.purple,
              )
            : Icon(
                _icons[1],
                size: size.width * 0.1,
                color: Colors.purple,
              ),
      ),
    );
  }

  Widget loadAsset(Size size) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                rewind();
              },
              child: Icon(
                Icons.replay_10,
                size: size.width * 0.07,
                color: subTextColor,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.skip_previous),
              iconSize: size.width * 0.07,
              color: subTextColor,
              onPressed: () {
                if (widget.index != 0) {
                  previous();
                }
              },
            ),
            btnStart(size),
            IconButton(
              icon: const Icon(Icons.skip_next),
              iconSize: size.width * 0.07,
              color: subTextColor,
              onPressed: () {
                if (currentIndex!.value != widget.max - 1) {
                  next();
                }
                print(currentIndex!.value);
                print(widget.max);
              },
            ),
            GestureDetector(
              onTap: () {
                if (currentIndex!.value != 0) {
                  previous();
                }
                print(currentIndex!.value);
                print(widget.max);
              },
              child: GestureDetector(
                onTap: () {
                  forward();
                },
                child: Icon(
                  Icons.forward_10,
                  size: size.width * 0.07,
                  color: subTextColor,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: size.height * 0.02,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              Icons.share,
              size: size.width * 0.07,
              color: subTextColor,
            ),
            IconButton(
              icon: const Icon(Icons.playlist_play),
              iconSize: size.width * 0.07,
              color: subTextColor,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    //update clicking playlist should open bottom modat sheet
                    builder: (context) => Playlist(
                      albumData: widget.albumData,
                      episodesData: widget.episodesData,
                      prebiousAudioPlayer: advancedAudioPlayer,
                      key: UniqueKey(),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        SizedBox(
          height: size.height * 0.02,
        ),
      ],
    );
  }

  Widget slider() {
    return Slider(
        activeColor: Colors.purple,
        inactiveColor: Colors.grey,
        min: 0.0,
        max: _duration.inSeconds.toDouble(),
        value: _position.inSeconds.toDouble(),
        onChanged: (double value) {
          setState(() {
            changeToSeconds(value.toInt());
            value = value;
          });
        });
  }

  void changeToSeconds(int second) {
    Duration newDuration = Duration(seconds: second);
    // if (newDuration >= _duration) {
    //   this.widget.advancedAudioPlayer.seek(_duration);
    // } else if (newDuration <= Duration(seconds: 0)) {
    //   this.widget.advancedAudioPlayer.seek(Duration(seconds: 0));
    // } else
    advancedAudioPlayer.seek(newDuration);
  }

  Duration changeToSeconds2(int second) {
    Duration newPosition = Duration(seconds: second);
    advancedAudioPlayer.seek(newPosition);
    if (newPosition > _duration) {
      return _duration;
    } else if (newPosition < const Duration(seconds: 0)) {
      return const Duration(seconds: 0);
    } else {
      return newPosition;
    }
  }

  void forward() {
    int newPosition = _position.inSeconds.toInt() + 10;

    setState(() {
      _position = changeToSeconds2(newPosition);
    });
  }

  void rewind() {
    int newPosition = _position.inSeconds.toInt() - 10;
    setState(() {
      _position = changeToSeconds2(newPosition);
    });
  }

  void next() {
    advancedAudioPlayer.stop();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => AudioDetails(
          albumData: widget.albumData,
          episodesData: widget.episodesData,
          index: widget.index + 1,
          max: widget.max,
          prebiousAudioPlayer: AudioPlayer(),
          key: UniqueKey(),
        ),
      ),
    );
  }

  void previous() {
    advancedAudioPlayer.stop();
    print((widget.index - 1).toString());
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => AudioDetails(
          albumData: widget.albumData,
          episodesData: widget.episodesData,
          index: widget.index - 1,
          max: widget.max,
          prebiousAudioPlayer: AudioPlayer(),
          key: UniqueKey(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ValueListenableBuilder(
        valueListenable: currentIndex!,
        builder: (context, int, _) {
          return Scaffold(
            backgroundColor: scaffoldColor,
            body: SafeArea(
              child: Container(
                height: size.height,
                width: size.width,
                padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: blackColor.withOpacity(0.05),
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
                              color: blackColor,
                              size: size.height * 0.03,
                            ),
                          ),
                        ),
                        Text(
                          'Now Playing',
                          style: TextStyle(
                            fontSize: size.width * 0.05,
                            color: Colors.purple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: blackColor.withOpacity(0.05),
                            borderRadius: BorderRadius.all(
                              Radius.circular(size.width * 0.05),
                            ),
                          ),
                          child: Icon(
                            Icons.bookmark_border,
                            color: blackColor,
                            size: size.height * 0.03,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    Expanded(
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(size.width * 0.05),
                              ),
                              image: DecorationImage(
                                image: NetworkImage(episode!['episodeImage']),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Center(
                            child: Text(status),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    Text(
                      widget.albumData['author'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: textColor,
                        fontSize: size.width * 0.045,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    Text(
                      widget.albumData['title'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: textColor,
                        fontSize: size.width * 0.05,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    Text(
                      'EP. ' +
                          widget.max.toString() +
                          ': ' +
                          episode!['episodeTitle'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: subTextColor,
                        fontSize: size.width * 0.04,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _position.toString().split(".")[0],
                              style: TextStyle(
                                  fontSize: 16.0, color: subTextColor),
                            ),
                            Text(
                              _duration.toString().split(".")[0],
                              style: TextStyle(
                                  fontSize: 16.0, color: subTextColor),
                            ),
                          ],
                        ),
                        slider(),
                        loadAsset(size),
                      ],
                    ),
                    // episodesData['audio']
                  ],
                ),
              ),
            ),
          );
        });
  }
}
