import 'package:listenme/generated/json/base/json_convert_content.dart';

import 'music_entity.dart';

class SearchMusicEntity with JsonConvert<SearchMusicEntity> {
	String name;
	String id;
	String cid;
	String mvId;
	String url;
	SearchMusicAlbum album;
	List<MusicArtist> artists;
}

class SearchMusicAlbum with JsonConvert<SearchMusicAlbum> {
	String picUrl;
	String name;
	String id;
}

