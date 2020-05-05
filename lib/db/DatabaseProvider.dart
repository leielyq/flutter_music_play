import 'package:listenme/db/PlayListDB.dart';
import 'package:listenme/db/PlayListDao.dart';

import 'todo_database.dart';
import 'todos_dao.dart';

class DatabaseProvider {
  TodosDao _todosDao;

  TodosDao get todosDao => _todosDao;

  DatabaseProvider() {
    TodoDatabase database = TodoDatabase();
    _todosDao = TodosDao(database);

    MusicDatabase musicDatabase = MusicDatabase();
    _musicsDao = MusicsDao(musicDatabase);
  }

  MusicsDao _musicsDao;

  MusicsDao get musicDao => _musicsDao;
}
