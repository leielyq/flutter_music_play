import 'package:flutter_leielyq_plugin/http/HttpUtil.dart';
import 'package:listenme/model/music_entity.dart';
import 'package:listenme/model/play_list_entity.dart';
import 'package:listenme/model/search_music_entity.dart';

class NetWork {
  static init() {
    HttpUtil().changBaseUrl('http://api.migu.jsososo.com/');
  }

  static Future<List> getPlayList(int pageNo, int type) async {
    var item =  await HttpUtil().getAwait('recommend/playlist', data: {
      'pageNo': pageNo,
      'type': type,
    });
    List list = item.data['data']['list'].map((res)=>PlayListEntity().fromJson(res)).toList();
   return list;
  }

  static Future<List> getMusicList(int pageNo, int pageSize) async {
    var item =  await HttpUtil().getAwait('new/songs', data: {
      'pageNo': pageNo,
      'pageSize': pageSize,
    });
    List list = item.data['data']['list'].map((res)=>MusicEntity().fromJson(res)).toList();
    return list;
  }
  static Future<List> search(String keyword, int pageNo) async {
    var item =  await HttpUtil().getAwait('search', data: {
      'pageNo': pageNo,
      'keyword': keyword,
    });
    List list = item.data['data']['list'].map((res)=>SearchMusicEntity().fromJson(res)).toList();
    return list;
  }

  static Future getMusicLyric(String cid) async {
    var item =  await HttpUtil().getAwait('lyric', data: {
      'cid': cid,
    });
    return item.data['data'];
  }




}
