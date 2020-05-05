import 'package:flutter/material.dart';
import 'package:flutter_leielyq_plugin/view/CustomListView2.dart';
import 'package:flutterpage/Page.dart';
import 'package:listenme/NetWork.dart';
import 'package:listenme/db/PlayListDB.dart';
import 'package:listenme/db/PlayListDao.dart';
import 'package:listenme/main.dart';
import 'package:listenme/model/music_entity.dart';
import 'package:listenme/model/search_music_entity.dart';
import 'package:moor/moor.dart';
import 'package:provider/provider.dart';

import 'db/DatabaseProvider.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends PageState<Search> {
  TextEditingController textEditingController =
      TextEditingController(text: '周杰伦 花海');

  @override
  Future<List> getData(int page) {
    return NetWork.search(textEditingController.text, page);
  }

  @override
  PreferredSizeWidget appBar() {
    return AppBar(
      title: Icon(Icons.search),
    );
  }

  @override
  Widget buildBody() {
    return CustomScrollView(
      slivers: <Widget>[
        CustomListView2(
          disableLoadingMore: true,
          endWidget: Container(),
          divider: SizedBox(
            height: 2,
          ),
          header: <Widget>[
            Hero(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: TextField(
                    maxLines: 1,
                    controller: textEditingController,
                    onSubmitted: (res) {
                      onRefresh();
                    },
                    decoration: InputDecoration(
                        icon: Icon(Icons.search), border: InputBorder.none),
                  ),
                ),
              ),
              tag: 'search',
            ),
          ],
          data: pageData,
          childBuilderDelegate: Item(),
        ),
      ],
    );
  }
}

class Item extends CustomChildBuilderDelegate2<SearchMusicEntity> {
  @override
  Widget build(BuildContext context, int index, data, List data2) {
    MusicsDao musicDao =
        Provider.of<DatabaseProvider>(context, listen: false).musicDao;

    return Card(
      child: RawMaterialButton(
        child: ListTile(
          leading: Image.network(data.album?.picUrl ?? ''),
          title: Text(data.name),
          subtitle: Row(
            children: data.artists.map((res) => Text(res.name)).toList(),
          ),
        ),
        onPressed: () {
          currentMusic = MusicEntity();
          currentMusic.cid = data.cid;
          currentMusic.id = data.id;
          currentMusic.url = data.url;
          currentMusic.name = data.name;
          currentMusic.artists = data.artists;
          currentMusic.picUrl = data.album?.picUrl ?? '';

          musicDao.insertMusic(MusicsCompanion(
              id: Value(data.id),
              cid: Value(data.cid),
              url: Value(data.url),
              picUrl: Value(data.album?.picUrl ?? ''),
              name: Value(data.name),
              artist: Value(data.artists[0].name)));

          audioPlayer.play(data.url);
        },
      ),
    );
  }
}
