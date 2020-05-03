import 'package:listenme/generated/json/base/json_convert_content.dart';

class PlayListEntity with JsonConvert<PlayListEntity> {
	String name;
	String id;
	String picUrl;
	int playCount;
	int songCount;
	PlayListCreator creator;
	String intro;
}

class PlayListCreator with JsonConvert<PlayListCreator> {
	String name;
	String id;
}
