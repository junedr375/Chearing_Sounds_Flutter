import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int m0 = 1, m1 = 1, m2 = 1, m3 = 1, m4 = 1, m5 = 1;
  String image1, image2, image3, image4, image5, image6;
  bool isPaused = true, isInitialized = false;

  final assetsAudioPlayer = AssetsAudioPlayer();

  Timer timer;

  List<String> musics = [
    'image/music/large_horn.mp3',
    'image/music/horn_short.mp3',
    'image/music/horn.mp3',
    'image/music/fan_horn.mp3',
    'image/music/whistle.mp3',
    'image/music/whistle2.mp3',
  ];

  Map<int, int> checkPressed = {0: 1, 1: 1, 2: 1, 3: 1, 4: 1, 5: 1};

  Map<int, dynamic> map = {
    0: {1: "image/images/horn_1.png", 2: "image/images/horn_1_pessed.png"},
    1: {1: "image/images/horn_2.png", 2: "image/images/horn_2_pessed.png"},
    2: {1: "image/images/tube.png", 2: "image/images/tube_pessed.png"},
    3: {1: "image/images/horn_3.png", 2: "image/images/horn_3_pessed.png"},
    4: {
      1: "image/images/whistle_1.png",
      2: "image/images/whistle_1_pessed.png"
    },
    5: {1: "image/images/whistle_2.png", 2: "image/images/whistle_2_pessed.png"}
  };

  @override
  void initState() {
    super.initState();
    timer =
        Timer.periodic(Duration(seconds: 1), (Timer t) => isMusicCompleted());
  }

  @override
  void dispose() {
    pauseMusic();
    stopMusic();
    super.dispose();
    timer.cancel();
    assetsAudioPlayer.dispose();
  }

  void isMusicCompleted() {
    if (isInitialized) {
      if (assetsAudioPlayer.isPlaying.value == false) {
        print('Here');
        for (int i = 0; i < checkPressed.length; i++) {
          setState(() {
            checkPressed[i] = 1;
          });
        }
      }
    }
  }

  void playMusic(String music) async {
    assetsAudioPlayer.open(
      Audio(music),
    );
    // final file = new File('${(await getTemporaryDirectory()).path}/$music.mp3');
    // await file.writeAsBytes((await loadAsset()).buffer.asUint8List());
    // final result = await audioPlayer.play(file.path, isLocal: true);
    // await audioCache.play(music);
  }

  void stopMusic() {
    assetsAudioPlayer.stop();
  }

  void pauseMusic() {
    assetsAudioPlayer.pause();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: height,
        width: width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('image/images/stadium.png'),
                fit: BoxFit.fill)),
        child: Center(
          child: GridView.builder(
            itemCount: 6,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 0,
                crossAxisSpacing: 0,
                childAspectRatio: 1),
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                  onTap: () {
                    if (checkPressed[index] == 1) {
                      // To Start Music
                      setState(() {
                        checkPressed[index] = 2;
                        // TO update others UI
                        for (int i = 0; i < checkPressed.length; i++) {
                          if (i != index) {
                            checkPressed[i] = 1;
                          }
                        }
                        if (!isInitialized) {
                          // TO check if initialized or not
                          playMusic(musics[index]);
                          setState(() {
                            isInitialized = true;
                          });
                        } else {
                          stopMusic();
                          playMusic(musics[index]);
                        }
                      });
                    } else {
                      // TO Stop Music on clicking again
                      setState(() {
                        checkPressed[index] = 1;
                        stopMusic();
                      });
                    }
                  },
                  child: Container(
                    height: 80,
                    width: 80,
                    child: Image.asset(
                      map[index][checkPressed[index]],
                      fit: BoxFit.fill,
                    ),
                  ));
            },
          ),
        ),
      ),
    );
  }
}
