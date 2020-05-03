// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types
// ignore_for_file: prefer_single_quotes

// This file is automatically generated. DO NOT EDIT, all your changes would be lost.
import 'package:listenme/model/play_list_entity.dart';
import 'package:listenme/generated/json/play_list_entity_helper.dart';
import 'package:listenme/model/music_entity.dart';
import 'package:listenme/generated/json/music_entity_helper.dart';

class JsonConvert<T> {
	T fromJson(Map<String, dynamic> json) {
		return _getFromJson<T>(runtimeType, this, json);
	}

  Map<String, dynamic> toJson() {
		return _getToJson<T>(runtimeType, this);
  }

  static _getFromJson<T>(Type type, data, json) {
    switch (type) {			case PlayListEntity:
			return playListEntityFromJson(data as PlayListEntity, json) as T;			case PlayListCreator:
			return playListCreatorFromJson(data as PlayListCreator, json) as T;			case MusicEntity:
			return musicEntityFromJson(data as MusicEntity, json) as T;			case MusicArtist:
			return musicArtistFromJson(data as MusicArtist, json) as T;    }
    return data as T;
  }

  static _getToJson<T>(Type type, data) {
		switch (type) {			case PlayListEntity:
			return playListEntityToJson(data as PlayListEntity);			case PlayListCreator:
			return playListCreatorToJson(data as PlayListCreator);			case MusicEntity:
			return musicEntityToJson(data as MusicEntity);			case MusicArtist:
			return musicArtistToJson(data as MusicArtist);    }
    return data as T;
  }
  //Go back to a single instance by type
  static _fromJsonSingle(String type, json) {
    switch (type) {			case 'PlayListEntity':
			return PlayListEntity().fromJson(json);			case 'PlayListCreator':
			return PlayListCreator().fromJson(json);			case 'MusicEntity':
			return MusicEntity().fromJson(json);			case 'MusicArtist':
			return MusicArtist().fromJson(json);    }
    return null;
  }

  //empty list is returned by type
  static _getListFromType(String type) {
    switch (type) {			case 'PlayListEntity':
			return List<PlayListEntity>();			case 'PlayListCreator':
			return List<PlayListCreator>();			case 'MusicEntity':
			return List<MusicEntity>();			case 'MusicArtist':
			return List<MusicArtist>();    }
    return null;
  }

  static M fromJsonAsT<M>(json) {
    String type = M.toString();
    if (json is List && type.contains("List<")) {
      String itemType = type.substring(5, type.length - 1);
      List tempList = _getListFromType(itemType);
      json.forEach((itemJson) {
        tempList
            .add(_fromJsonSingle(type.substring(5, type.length - 1), itemJson));
      });
      return tempList as M;
    } else {
      return _fromJsonSingle(M.toString(), json) as M;
    }
  }
}