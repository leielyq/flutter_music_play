import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/rendering/sliver.dart';
import 'package:flutter/src/rendering/sliver_grid.dart';
import 'package:flutterpage/Page.dart';
import 'package:listenme/Global.dart';
import 'package:listenme/MyTabIndicator.dart';
import 'package:listenme/NetWork.dart';
import 'package:listenme/model/play_list_entity.dart';
import 'package:listenme/play/PlayKits.dart';
import 'package:listenme/search.dart';
import 'package:listenme/ui/play_list_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'db/DatabaseProvider.dart';
import 'model/music_entity.dart';

void main() {
  _setTargetPlatformForDesktop();
  runApp(MyApp());
}

void _setTargetPlatformForDesktop() {
  TargetPlatform targetPlatform;
  if (Platform.isMacOS) {
    targetPlatform = TargetPlatform.iOS;
  } else if (Platform.isLinux || Platform.isWindows) {
    targetPlatform = TargetPlatform.android;
  }
  if (targetPlatform != null) {
    debugDefaultTargetPlatformOverride = targetPlatform;
  }

}

AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);
AudioCache audioCache = AudioCache();

MusicEntity currentMusic;

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    NetWork.init();
    getTemporaryDirectory().then((Directory res){
      print(res.path);
    });
    return MultiProvider(
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'Flutter Demo Home Page'),
      ),
      providers: [
        Provider(create: (_) => DatabaseProvider()),
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
  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      return;
    }
    if (App.isiOS) {
      if (audioCache.fixedPlayer != null) {
        audioCache.fixedPlayer.startHeadlessService();
      }
      audioPlayer.startHeadlessService();
    }

    audioPlayer.setReleaseMode(ReleaseMode.LOOP);

    audioPlayer.onPlayerStateChanged
        .listen((AudioPlayerState s) => {print('Current player state: $s')});
  }

  @override
  Future<List> getData(int page) {
    return NetWork.getMusicList(page, 10);
  }

  int _angle = 0;

  @override
  Widget buildTwoLevelWidget() {
    if (currentMusic == null) {
      return null;
    }
    return DefaultTabController(
      child: Scaffold(
        backgroundColor: Theme.of(context).cardColor,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Container(
            child: TabBar(
                unselectedLabelColor: Colors.grey,
                indicator:
                    MyTabIndicator(color: Theme.of(context).primaryColor),
                tabs: [
                  Tab(
                    icon: Icon(Icons.album),
                  ),
                  Tab(
                    icon: Icon(Icons.book),
                  )
                ]),
          ),
        ),
        bottomNavigationBar: FutureBuilder(
          future: audioPlayer.getDuration(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            return Container(
              height: 200,
              child: ToolWidget(
                total: snapshot.data.toDouble(),
              ),
            );
          },
        ),
        body: Column(
          children: <Widget>[
            Flexible(
              child: TabBarView(children: [
                ListView(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _angle == 0 ? _angle = 90 : _angle = 0;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 60),
                        child: AnimatedContainer(
                          transform: Matrix4.identity()..rotateZ(0),
                          child: ClipOval(
                            child: Container(
                              width: 200,
                              child: Image.network(
                                currentMusic.picUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          duration: Duration(seconds: 1),
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text(currentMusic.name),
                      subtitle: Row(
                        children: currentMusic.artists
                            .map((res) => Text(res.name))
                            .toList(),
                      ),
                    ),
                  ],
                ),
                ListView(
                  children: <Widget>[
                    FutureBuilder(
                      future: NetWork.getMusicLyric(currentMusic.cid),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (ConnectionState.waiting ==
                            snapshot.connectionState) {
                          return CircularProgressIndicator();
                        }
                        return Text(snapshot.data.toString());
                      },
                    )
                  ],
                ),
              ]),
            )
          ],
        ),
      ),
      length: 2,
    );
  }

  @override
  Widget buildBody() {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          title: currentMusic == null
              ? Text('Listen Me')
              : IconButton(
                  icon: Icon(Icons.vertical_align_bottom),
                  onPressed: () {
                    openTwoWidget();
                  }),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.list),
                onPressed: () {
                  Navigator.of(context).push(
                      CupertinoPageRoute(builder: (context) => PlayListPage()));
                })
          ],
        ),
        SliverToBoxAdapter(
          child: RawMaterialButton(
            child: Hero(
              child: Text(
                '搜索',
                style: Theme.of(context).textTheme.title,
              ),
              tag: 'search',
            ),
            onPressed: () {
              Navigator.of(context)
                  .push(CupertinoPageRoute(builder: (context) => Search()));
            },
          ),
        ),
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
                  audioPlayer.stop();
                  audioPlayer.play(currentMusic.url);
                  PlayKits.play(currentMusic.url);
                  openTwoWidget();
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

class ToolWidget extends StatefulWidget {
  final total;

  const ToolWidget({
    Key key,
    this.total,
  }) : super(key: key);

  @override
  _ToolWidgetState createState() => _ToolWidgetState();
}

class _ToolWidgetState extends State<ToolWidget> {
  StreamController<AudioPlayerState> streamController = StreamController();

  @override
  void initState() {
    super.initState();
    audioPlayer.onPlayerStateChanged.listen((AudioPlayerState s) {
      print('Current player state: $s');
      streamController.sink.add(s);
    });
  }

  @override
  Widget build(BuildContext context) {
    final audioPosition = Provider.of<Duration>(context);
//    print(audioPosition.toString());
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: SliderTheme(
                  data: SliderTheme.of(context)
                      .copyWith(activeTickMarkColor: Colors.orange),
                  child: Slider.adaptive(
                      min: 0,
                      max: widget.total,
                      label: '${audioPosition.inMilliseconds}',
                      value: audioPosition.inMilliseconds.toDouble(),
                      onChanged: (double value) {
                        audioPlayer.seek(Duration(milliseconds: value.toInt()));
                      })),
            ),
            Text(widget.total.toString())
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(icon: Icon(Icons.keyboard_arrow_left), onPressed: null),
            Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  boxShadow: [BoxShadow()],
                  shape: BoxShape.circle),
              child: StreamBuilder<AudioPlayerState>(
                  stream: streamController.stream,
                  initialData: AudioPlayerState.PLAYING,
                  builder: (context, snapshot) {
                    print(snapshot.data.toString());
                    switch (snapshot.data) {
                      case AudioPlayerState.STOPPED:
                        return IconButton(
                            icon: Icon(
                              Icons.play_arrow,
                              color: Theme.of(context).cardColor,
                            ),
                            onPressed: () {
                              audioPlayer.play(currentMusic.url);
                            });
                        break;
                      case AudioPlayerState.PLAYING:
                        return IconButton(
                            icon: Icon(
                              Icons.pause,
                              color: Theme.of(context).cardColor,
                            ),
                            onPressed: () {
                              audioPlayer.pause();
                            });
                        break;
                      case AudioPlayerState.PAUSED:
                        return IconButton(
                            icon: Icon(
                              Icons.play_arrow,
                              color: Theme.of(context).cardColor,
                            ),
                            onPressed: () {
                              audioPlayer.resume();
                            });
                        break;
                      case AudioPlayerState.COMPLETED:
                        return IconButton(
                            icon: Icon(
                              Icons.play_arrow,
                              color: Theme.of(context).cardColor,
                            ),
                            onPressed: () {
                              audioPlayer.play(currentMusic.url);
                            });
                        break;
                    }
                    return IconButton(
                        icon: Icon(
                          Icons.play_arrow,
                          color: Theme.of(context).cardColor,
                        ),
                        onPressed: () {
                          audioPlayer.play(currentMusic.url);
                        });
                  }),
            ),
            IconButton(icon: Icon(Icons.keyboard_arrow_right), onPressed: null)
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(icon: Icon(Icons.playlist_add), onPressed: null),
            IconButton(icon: Icon(Icons.playlist_play), onPressed: null),
            IconButton(
                icon: Icon(Icons.replay),
                onPressed: () {
                  audioPlayer.setReleaseMode(ReleaseMode.LOOP);
                }),
            IconButton(icon: Icon(Icons.share), onPressed: null)
          ],
        ),
        Center(
          child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  boxShadow: [BoxShadow()],
                  shape: BoxShape.circle),
              child: IconButton(
                icon: Icon(Icons.vertical_align_top),
                onPressed: () {
                  SmartRefresher.of(context).controller.twoLevelComplete();
                },
              )),
        )
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
