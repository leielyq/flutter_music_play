import 'package:listenme/model/play_list_entity.dart';

playListEntityFromJson(PlayListEntity data, Map<String, dynamic> json) {
	if (json['name'] != null) {
		data.name = json['name']?.toString();
	}
	if (json['id'] != null) {
		data.id = json['id']?.toString();
	}
	if (json['picUrl'] != null) {
		data.picUrl = json['picUrl']?.toString();
	}
	if (json['playCount'] != null) {
		data.playCount = json['playCount']?.toInt();
	}
	if (json['songCount'] != null) {
		data.songCount = json['songCount']?.toInt();
	}
	if (json['creator'] != null) {
		data.creator = new PlayListCreator().fromJson(json['creator']);
	}
	if (json['intro'] != null) {
		data.intro = json['intro']?.toString();
	}
	return data;
}

Map<String, dynamic> playListEntityToJson(PlayListEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['name'] = entity.name;
	data['id'] = entity.id;
	data['picUrl'] = entity.picUrl;
	data['playCount'] = entity.playCount;
	data['songCount'] = entity.songCount;
	if (entity.creator != null) {
		data['creator'] = entity.creator.toJson();
	}
	data['intro'] = entity.intro;
	return data;
}

playListCreatorFromJson(PlayListCreator data, Map<String, dynamic> json) {
	if (json['name'] != null) {
		data.name = json['name']?.toString();
	}
	if (json['id'] != null) {
		data.id = json['id']?.toString();
	}
	return data;
}

Map<String, dynamic> playListCreatorToJson(PlayListCreator entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['name'] = entity.name;
	data['id'] = entity.id;
	return data;
}