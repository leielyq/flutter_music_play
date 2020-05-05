// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PlayListDB.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Music extends DataClass implements Insertable<Music> {
  final String id;
  final String cid;
  final String name;
  final String url;
  final String picUrl;
  final String artist;
  Music(
      {@required this.id,
      @required this.cid,
      @required this.name,
      @required this.url,
      @required this.picUrl,
      @required this.artist});
  factory Music.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    return Music(
      id: stringType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      cid: stringType.mapFromDatabaseResponse(data['${effectivePrefix}cid']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      url: stringType.mapFromDatabaseResponse(data['${effectivePrefix}url']),
      picUrl:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}pic_url']),
      artist:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}artist']),
    );
  }
  factory Music.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Music(
      id: serializer.fromJson<String>(json['id']),
      cid: serializer.fromJson<String>(json['cid']),
      name: serializer.fromJson<String>(json['name']),
      url: serializer.fromJson<String>(json['url']),
      picUrl: serializer.fromJson<String>(json['picUrl']),
      artist: serializer.fromJson<String>(json['artist']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'cid': serializer.toJson<String>(cid),
      'name': serializer.toJson<String>(name),
      'url': serializer.toJson<String>(url),
      'picUrl': serializer.toJson<String>(picUrl),
      'artist': serializer.toJson<String>(artist),
    };
  }

  @override
  MusicsCompanion createCompanion(bool nullToAbsent) {
    return MusicsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      cid: cid == null && nullToAbsent ? const Value.absent() : Value(cid),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      url: url == null && nullToAbsent ? const Value.absent() : Value(url),
      picUrl:
          picUrl == null && nullToAbsent ? const Value.absent() : Value(picUrl),
      artist:
          artist == null && nullToAbsent ? const Value.absent() : Value(artist),
    );
  }

  Music copyWith(
          {String id,
          String cid,
          String name,
          String url,
          String picUrl,
          String artist}) =>
      Music(
        id: id ?? this.id,
        cid: cid ?? this.cid,
        name: name ?? this.name,
        url: url ?? this.url,
        picUrl: picUrl ?? this.picUrl,
        artist: artist ?? this.artist,
      );
  @override
  String toString() {
    return (StringBuffer('Music(')
          ..write('id: $id, ')
          ..write('cid: $cid, ')
          ..write('name: $name, ')
          ..write('url: $url, ')
          ..write('picUrl: $picUrl, ')
          ..write('artist: $artist')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          cid.hashCode,
          $mrjc(name.hashCode,
              $mrjc(url.hashCode, $mrjc(picUrl.hashCode, artist.hashCode))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Music &&
          other.id == this.id &&
          other.cid == this.cid &&
          other.name == this.name &&
          other.url == this.url &&
          other.picUrl == this.picUrl &&
          other.artist == this.artist);
}

class MusicsCompanion extends UpdateCompanion<Music> {
  final Value<String> id;
  final Value<String> cid;
  final Value<String> name;
  final Value<String> url;
  final Value<String> picUrl;
  final Value<String> artist;
  const MusicsCompanion({
    this.id = const Value.absent(),
    this.cid = const Value.absent(),
    this.name = const Value.absent(),
    this.url = const Value.absent(),
    this.picUrl = const Value.absent(),
    this.artist = const Value.absent(),
  });
  MusicsCompanion.insert({
    @required String id,
    @required String cid,
    @required String name,
    @required String url,
    @required String picUrl,
    @required String artist,
  })  : id = Value(id),
        cid = Value(cid),
        name = Value(name),
        url = Value(url),
        picUrl = Value(picUrl),
        artist = Value(artist);
  MusicsCompanion copyWith(
      {Value<String> id,
      Value<String> cid,
      Value<String> name,
      Value<String> url,
      Value<String> picUrl,
      Value<String> artist}) {
    return MusicsCompanion(
      id: id ?? this.id,
      cid: cid ?? this.cid,
      name: name ?? this.name,
      url: url ?? this.url,
      picUrl: picUrl ?? this.picUrl,
      artist: artist ?? this.artist,
    );
  }
}

class $MusicsTable extends Musics with TableInfo<$MusicsTable, Music> {
  final GeneratedDatabase _db;
  final String _alias;
  $MusicsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedTextColumn _id;
  @override
  GeneratedTextColumn get id => _id ??= _constructId();
  GeneratedTextColumn _constructId() {
    return GeneratedTextColumn(
      'id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _cidMeta = const VerificationMeta('cid');
  GeneratedTextColumn _cid;
  @override
  GeneratedTextColumn get cid => _cid ??= _constructCid();
  GeneratedTextColumn _constructCid() {
    return GeneratedTextColumn(
      'cid',
      $tableName,
      false,
    );
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  @override
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn('name', $tableName, false,
        minTextLength: 1, maxTextLength: 50);
  }

  final VerificationMeta _urlMeta = const VerificationMeta('url');
  GeneratedTextColumn _url;
  @override
  GeneratedTextColumn get url => _url ??= _constructUrl();
  GeneratedTextColumn _constructUrl() {
    return GeneratedTextColumn(
      'url',
      $tableName,
      false,
    );
  }

  final VerificationMeta _picUrlMeta = const VerificationMeta('picUrl');
  GeneratedTextColumn _picUrl;
  @override
  GeneratedTextColumn get picUrl => _picUrl ??= _constructPicUrl();
  GeneratedTextColumn _constructPicUrl() {
    return GeneratedTextColumn(
      'pic_url',
      $tableName,
      false,
    );
  }

  final VerificationMeta _artistMeta = const VerificationMeta('artist');
  GeneratedTextColumn _artist;
  @override
  GeneratedTextColumn get artist => _artist ??= _constructArtist();
  GeneratedTextColumn _constructArtist() {
    return GeneratedTextColumn(
      'artist',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, cid, name, url, picUrl, artist];
  @override
  $MusicsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'musics';
  @override
  final String actualTableName = 'musics';
  @override
  VerificationContext validateIntegrity(MusicsCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (d.cid.present) {
      context.handle(_cidMeta, cid.isAcceptableValue(d.cid.value, _cidMeta));
    } else if (isInserting) {
      context.missing(_cidMeta);
    }
    if (d.name.present) {
      context.handle(
          _nameMeta, name.isAcceptableValue(d.name.value, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (d.url.present) {
      context.handle(_urlMeta, url.isAcceptableValue(d.url.value, _urlMeta));
    } else if (isInserting) {
      context.missing(_urlMeta);
    }
    if (d.picUrl.present) {
      context.handle(
          _picUrlMeta, picUrl.isAcceptableValue(d.picUrl.value, _picUrlMeta));
    } else if (isInserting) {
      context.missing(_picUrlMeta);
    }
    if (d.artist.present) {
      context.handle(
          _artistMeta, artist.isAcceptableValue(d.artist.value, _artistMeta));
    } else if (isInserting) {
      context.missing(_artistMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Music map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Music.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(MusicsCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<String, StringType>(d.id.value);
    }
    if (d.cid.present) {
      map['cid'] = Variable<String, StringType>(d.cid.value);
    }
    if (d.name.present) {
      map['name'] = Variable<String, StringType>(d.name.value);
    }
    if (d.url.present) {
      map['url'] = Variable<String, StringType>(d.url.value);
    }
    if (d.picUrl.present) {
      map['pic_url'] = Variable<String, StringType>(d.picUrl.value);
    }
    if (d.artist.present) {
      map['artist'] = Variable<String, StringType>(d.artist.value);
    }
    return map;
  }

  @override
  $MusicsTable createAlias(String alias) {
    return $MusicsTable(_db, alias);
  }
}

abstract class _$MusicDatabase extends GeneratedDatabase {
  _$MusicDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $MusicsTable _musics;
  $MusicsTable get musics => _musics ??= $MusicsTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [musics];
}
