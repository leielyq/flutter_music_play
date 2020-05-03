import 'package:listenme/generated/json/base/json_convert_content.dart';

class MusicEntity with JsonConvert<MusicEntity> {
	String name;
	String id;
	String cid;
	List<MusicArtist> artists;
	String picUrl;
	String url;
}

class MusicArtist with JsonConvert<MusicArtist> {
	String name;
	String id;
}
