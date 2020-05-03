import 'package:listenme/model/music_entity.dart';

musicEntityFromJson(MusicEntity data, Map<String, dynamic> json) {
	if (json['name'] != null) {
		data.name = json['name']?.toString();
	}
	if (json['id'] != null) {
		data.id = json['id']?.toString();
	}
	if (json['cid'] != null) {
		data.cid = json['cid']?.toString();
	}
	if (json['artists'] != null) {
		data.artists = new List<MusicArtist>();
		(json['artists'] as List).forEach((v) {
			data.artists.add(new MusicArtist().fromJson(v));
		});
	}
	if (json['picUrl'] != null) {
		data.picUrl = json['picUrl']?.toString();
	}
	if (json['url'] != null) {
		data.url = json['url']?.toString();
	}
	return data;
}

Map<String, dynamic> musicEntityToJson(MusicEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['name'] = entity.name;
	data['id'] = entity.id;
	data['cid'] = entity.cid;
	if (entity.artists != null) {
		data['artists'] =  entity.artists.map((v) => v.toJson()).toList();
	}
	data['picUrl'] = entity.picUrl;
	data['url'] = entity.url;
	return data;
}

musicArtistFromJson(MusicArtist data, Map<String, dynamic> json) {
	if (json['name'] != null) {
		data.name = json['name']?.toString();
	}
	if (json['id'] != null) {
		data.id = json['id']?.toString();
	}
	return data;
}

Map<String, dynamic> musicArtistToJson(MusicArtist entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['name'] = entity.name;
	data['id'] = entity.id;
	return data;
}