import 'package:listenme/db/PlayListDB.dart';
import 'package:moor/moor.dart';
part 'PlayListDao.g.dart';

// the _MusicsDaoMixin will be created by moor. It contains all the necessary
// fields for the tables. The <MyDatabase> type annotation is the database class
// that should use this dao.
@UseDao(tables: [Musics])
class MusicsDao extends DatabaseAccessor<MusicDatabase> with _$MusicsDaoMixin {
  // this constructor is required so that the main database can create an instance
  // of this object.
  MusicsDao(MusicDatabase db) : super(db);

  Future<List<Music>> getAllMusics() => select(musics).get();

  Stream<List<Music>> watchAllMusics() => select(musics).watch();

  Future insertMusic(MusicsCompanion Music) => into(musics).insert(Music);

  Future updateMusic(Music Music) => update(musics).replace(Music);

  Future deleteMusic(Music Music) => delete(musics).delete(Music);
}
