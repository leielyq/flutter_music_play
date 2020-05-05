import 'dart:io';

import 'package:moor/moor.dart';
import 'package:moor_ffi/moor_ffi.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'PlayListDB.g.dart';

// this will generate a table called "Musics" for us. The rows of that table will
// be represented by a class called "Music".
class Musics extends Table {
  TextColumn get id => text()();

  TextColumn get cid => text()();

  TextColumn get name => text().withLength(min: 1, max: 50)();

  TextColumn get url => text()();

  TextColumn get picUrl => text()();

  TextColumn get artist => text()();

  @override
  // TODO: implement primaryKey
  Set<Column> get primaryKey => {id};

}

@UseMoor(tables: [Musics])
class MusicDatabase extends _$MusicDatabase {
  // we tell the database where to store the data with this constructor
  MusicDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return VmDatabase(file, logStatements: true);
  });
}
