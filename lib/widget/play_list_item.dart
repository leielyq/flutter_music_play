import 'package:flutter/material.dart';
import 'package:listenme/db/DatabaseProvider.dart';
import 'package:listenme/db/PlayListDB.dart';
import 'package:listenme/db/PlayListDao.dart';
import 'package:listenme/model/music_entity.dart';
import 'package:moor/moor.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class MusicItemWidget extends StatelessWidget {
  final cid;
  final id;
  final url;
  final name;
  final List<MusicArtist> artists;
  final picUrl;

  const MusicItemWidget({
    Key key,
    this.cid,
    this.id,
    this.url,
    this.name,
    this.artists,
    this.picUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MusicsDao musicDao =
        Provider.of<DatabaseProvider>(context, listen: false).musicDao;
    print(artists[0].name);
    List<Widget> list = [];
    artists.map((res) {
      list.add(Text(res.name));
    });

    return Card(
      child: RawMaterialButton(
        child: ListTile(
          leading: Image.network(picUrl),
          title: Text(name),
          subtitle: Row(
            children: list??[],
          ),
        ),
        onPressed: () {
          MusicEntity currentMusic = MusicEntity();
          currentMusic.cid = cid;
//          currentMusic.id = id.toInt();
          currentMusic.url = url;
          currentMusic.name = name;
          currentMusic.artists = artists;
          currentMusic.picUrl = picUrl ?? '';

          musicDao.insertMusic(MusicsCompanion(
              cid: Value(cid),
              url: Value(url),
              picUrl: Value(picUrl ?? ''),
              name: Value(name),
              artist: Value(artists[0].name)));

          audioPlayer.play(url);
        },
      ),
    );
  }
}
