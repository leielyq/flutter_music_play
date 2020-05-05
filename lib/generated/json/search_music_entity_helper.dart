import 'package:listenme/model/music_entity.dart';
import 'package:listenme/model/search_music_entity.dart';

searchMusicEntityFromJson(SearchMusicEntity data, Map<String, dynamic> json) {
	if (json['name'] != null) {
		data.name = json['name']?.toString();
	}
	if (json['id'] != null) {
		data.id = json['id']?.toString();
	}
	if (json['cid'] != null) {
		data.cid = json['cid']?.toString();
	}
	if (json['mvId'] != null) {
		data.mvId = json['mvId']?.toString();
	}
	if (json['url'] != null) {
		data.url = json['url']?.toString();
	}
	if (json['album'] != null) {
		data.album = new SearchMusicAlbum().fromJson(json['album']);
	}
	if (json['artists'] != null) {
		data.artists = new List<MusicArtist>();
		(json['artists'] as List).forEach((v) {
			data.artists.add(new MusicArtist().fromJson(v));
		});
	}
	return data;
}

Map<String, dynamic> searchMusicEntityToJson(SearchMusicEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['name'] = entity.name;
	data['id'] = entity.id;
	data['cid'] = entity.cid;
	data['mvId'] = entity.mvId;
	data['url'] = entity.url;
	if (entity.album != null) {
		data['album'] = entity.album.toJson();
	}
	if (entity.artists != null) {
		data['artists'] =  entity.artists.map((v) => v.toJson()).toList();
	}
	return data;
}

searchMusicAlbumFromJson(SearchMusicAlbum data, Map<String, dynamic> json) {
	if (json['picUrl'] != null) {
		data.picUrl = json['picUrl']?.toString();
	}
	if (json['name'] != null) {
		data.name = json['name']?.toString();
	}
	if (json['id'] != null) {
		data.id = json['id']?.toString();
	}
	return data;
}

Map<String, dynamic> searchMusicAlbumToJson(SearchMusicAlbum entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['picUrl'] = entity.picUrl;
	data['name'] = entity.name;
	data['id'] = entity.id;
	return data;
}

searchMusicArtistFromJson(MusicArtist data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id']?.toString();
	}
	if (json['name'] != null) {
		data.name = json['name']?.toString();
	}
	return data;
}

Map<String, dynamic> searchMusicArtistToJson(MusicArtist entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['name'] = entity.name;
	return data;
}