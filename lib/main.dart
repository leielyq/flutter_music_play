import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/rendering/sliver.dart';
import 'package:flutter/src/rendering/sliver_grid.dart';
import 'package:flutterpage/Page.dart';
import 'package:listenme/Global.dart';
import 'package:listenme/NetWork.dart';
import 'package:listenme/model/play_list_entity.dart';
import 'package:provider/provider.dart';

import 'model/music_entity.dart';

void main() => runApp(MyApp());

AudioPlayer audioPlayer = AudioPlayer();
AudioCache audioCache = AudioCache();

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    NetWork.init();

    return MultiProvider(
      child:
      MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'Flutter Demo Home Page'),
      ),
      providers: [
        StreamProvider<Duration>.value(
            initialData: Duration(), value: audioPlayer.onAudioPositionChanged),
      ],
    );

  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends PageState<MyHomePage> {
  MusicEntity currentMusic;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      // Calls to Platform.isIOS fails on web
      return;
    }
    if (App.isiOS) {
      if (audioCache.fixedPlayer != null) {
        audioCache.fixedPlayer.startHeadlessService();
      }
      audioPlayer.startHeadlessService();
    }
  }

  @override
  Future<List> getData(int page) {
    return NetWork.getMusicList(page, 10);
  }

  @override
  Widget buildTwoLevelWidget() {
    if (currentMusic == null) {
      return null;
    }

    return Scaffold(
      body: Column(
        children: <Widget>[
          ListTile(
            leading: Image.network(
              currentMusic.picUrl,
              width: 50,
            ),
            title: Text(currentMusic.name),
            subtitle: Row(
              children:
                  currentMusic.artists.map((res) => Text(res.name)).toList(),
            ),
          ),
          Flexible(child: Text('歌词')),
          Advanced(
            advancedPlayer: audioPlayer,
          )
        ],
      ),
    );
  }

  @override
  Widget buildBody() {
    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: Text(
            'Today',
            style: Theme.of(context).textTheme.title,
          ),
        ),
        SliverGrid(
          delegate: SliverChildBuilderDelegate((context, index) {
            MusicEntity item = pageData[index];
            return Card(
              child: RawMaterialButton(
                child: GridTile(
                  child: Image.network(item.picUrl),
                ),
                onPressed: () {
                  setState(() {
                    currentMusic = item;
                  });
                  audioPlayer.play(currentMusic.url);
                },
              ),
            );
          }, childCount: pageData.length),
          gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        ),
      ],
    );


  }
}

class Advanced extends StatefulWidget {
  final AudioPlayer advancedPlayer;

  const Advanced({Key key, this.advancedPlayer}) : super(key: key);

  @override
  _AdvancedState createState() => _AdvancedState();
}

class _AdvancedState extends State<Advanced> {
  bool seekDone;

  @override
  void initState() {
    widget.advancedPlayer.seekCompleteHandler =
        (finished) => setState(() => seekDone = finished);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final audioPosition = Provider.of<Duration>(context);
    return SingleChildScrollView(
      child: _Tab(
        children: [
          Column(children: [
            Text('Release Mode'),
            Row(children: [
              _Btn(
                  txt: 'STOP',
                  onPressed: () =>
                      widget.advancedPlayer.setReleaseMode(ReleaseMode.STOP)),
              _Btn(
                  txt: 'LOOP',
                  onPressed: () =>
                      widget.advancedPlayer.setReleaseMode(ReleaseMode.LOOP)),
              _Btn(
                  txt: 'RELEASE',
                  onPressed: () => widget.advancedPlayer
                      .setReleaseMode(ReleaseMode.RELEASE)),
            ], mainAxisAlignment: MainAxisAlignment.spaceEvenly),
          ]),
          Column(children: [
            Text('Volume'),
            Row(children: [
              _Btn(
                  txt: '0.0',
                  onPressed: () => widget.advancedPlayer.setVolume(0.0)),
              _Btn(
                  txt: '0.5',
                  onPressed: () => widget.advancedPlayer.setVolume(0.5)),
              _Btn(
                  txt: '1.0',
                  onPressed: () => widget.advancedPlayer.setVolume(1.0)),
              _Btn(
                  txt: '2.0',
                  onPressed: () => widget.advancedPlayer.setVolume(2.0)),
            ], mainAxisAlignment: MainAxisAlignment.spaceEvenly),
          ]),
          Column(children: [
            Text('Control'),
            Row(children: [
              _Btn(
                  txt: 'resume',
                  onPressed: () => widget.advancedPlayer.resume()),
              _Btn(
                  txt: 'pause', onPressed: () => widget.advancedPlayer.pause()),
              _Btn(txt: 'stop', onPressed: () => widget.advancedPlayer.stop()),
              _Btn(
                  txt: 'release',
                  onPressed: () => widget.advancedPlayer.release()),
            ], mainAxisAlignment: MainAxisAlignment.spaceEvenly),
          ]),
          Column(children: [
            Text('Seek in milliseconds'),
            Row(children: [
              _Btn(
                  txt: '100ms',
                  onPressed: () {
                    widget.advancedPlayer.seek(Duration(
                        milliseconds: audioPosition.inMilliseconds + 100));
                    setState(() => seekDone = false);
                  }),
              _Btn(
                  txt: '500ms',
                  onPressed: () {
                    widget.advancedPlayer.seek(Duration(
                        milliseconds: audioPosition.inMilliseconds + 500));
                    setState(() => seekDone = false);
                  }),
              _Btn(
                  txt: '1s',
                  onPressed: () {
                    widget.advancedPlayer
                        .seek(Duration(seconds: audioPosition.inSeconds + 1));
                    setState(() => seekDone = false);
                  }),
              _Btn(
                  txt: '1.5s',
                  onPressed: () {
                    widget.advancedPlayer.seek(Duration(
                        milliseconds: audioPosition.inMilliseconds + 1500));
                    setState(() => seekDone = false);
                  }),
            ], mainAxisAlignment: MainAxisAlignment.spaceEvenly),
          ]),
          Column(children: [
            Text('Rate'),
            Row(children: [
              _Btn(
                  txt: '0.5',
                  onPressed: () =>
                      widget.advancedPlayer.setPlaybackRate(playbackRate: 0.5)),
              _Btn(
                  txt: '1.0',
                  onPressed: () =>
                      widget.advancedPlayer.setPlaybackRate(playbackRate: 1.0)),
              _Btn(
                  txt: '1.5',
                  onPressed: () =>
                      widget.advancedPlayer.setPlaybackRate(playbackRate: 1.5)),
              _Btn(
                  txt: '2.0',
                  onPressed: () =>
                      widget.advancedPlayer.setPlaybackRate(playbackRate: 2.0)),
            ], mainAxisAlignment: MainAxisAlignment.spaceEvenly),
          ]),
          Text('Audio Position: ${audioPosition}'),
          seekDone == null
              ? SizedBox(
                  width: 0,
                  height: 0,
                )
              : Text(seekDone ? "Seek Done" : "Seeking..."),
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  final List<Widget> children;

  const _Tab({Key key, this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        alignment: Alignment.topCenter,
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: children
                .map((w) => Container(child: w, padding: EdgeInsets.all(6.0)))
                .toList(),
          ),
        ),
      ),
    );
  }
}

class _Btn extends StatelessWidget {
  final String txt;
  final Function onPressed;

  const _Btn({Key key, this.txt, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
        minWidth: 48.0,
        child: RaisedButton(child: Text(txt), onPressed: onPressed));
  }
}
