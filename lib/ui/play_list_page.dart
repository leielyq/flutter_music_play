import 'package:flutter/material.dart';
import 'package:flutterpage/Page.dart';
import 'package:listenme/db/DatabaseProvider.dart';
import 'package:listenme/db/PlayListDB.dart';
import 'package:listenme/db/PlayListDao.dart';
import 'package:listenme/model/music_entity.dart';
import 'package:listenme/widget/play_list_item.dart';
import 'package:provider/provider.dart';

class PlayListPage extends StatefulWidget {
  @override
  _PlayListPageState createState() => _PlayListPageState();
}

class _PlayListPageState extends PageState<PlayListPage> {
  @override
  Future<List> getData(int page) {
    MusicsDao musicDao =
        Provider.of<DatabaseProvider>(context, listen: false).musicDao;
    return musicDao.getAllMusics();
  }

  @override
  Widget buildBody() {
    return ListView.separated(
      itemCount: pageData.length,
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          height: 1,
        );
      },
      itemBuilder: (BuildContext context, int index) {
        Music music = pageData[index];
        var a = MusicArtist()..name = music.artist;
        return MusicItemWidget(
          id: music.id,
          cid: music.cid,
          url: music.url,
          name: music.name,
          artists: [a],
          picUrl: music.picUrl,
        );
      },
    );
  }
}
