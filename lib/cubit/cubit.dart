import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/cubit/states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());
// using cubit we can access any thing found in it in another dart file using method return AppCubit (State) using BlocProvider
  static AppCubit get(context) => BlocProvider.of(context);

  List<Map> tasks = [];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];

  late Database database;

  /// create database
  void createDatabase() async {
    database = await openDatabase('path.db', version: 1,
        onCreate: (database, version) {
      database.execute(
          'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, time TEXT, date TEXT, notes TEXT)');
    }, onOpen: (database) {
      getDataFromDatabase(database);
    });
  }

  /// inset to database
  insertToDatabase({
    required String title,
    required String time,
    required String date,
    required String notes,
  }) async {
    await database.transaction((txn) {
      return txn
          .rawInsert(
              'INSERT INTO tasks (title, time, date, notes) VALUES("$title", "$time", "$date" , "notes")')
          .then((value) {
        getDataFromDatabase(database);
        emit(AppInsertDatabaseSuccessState());
      }).catchError((error) {
        emit(AppInsertDatabaseErrorState(error.toString()));
      });
    });
  }

  /// get data from database
  void getDataFromDatabase(database) async {
    tasks.clear();
    doneTasks.clear();
    archiveTasks.clear();
    await database.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((e) {
        if (e['notes'] == 'done') {
          doneTasks.add(e);
        } else if (e['notes'] == 'archive') {
          archiveTasks.add(e);
        } else {
          tasks.add(e);
        }
      });
    });
    emit(AppGetDatabaseSuccessState());
  }

  /// delete data from database
  void deleteFromDateBase(int id) async {
    await database
        .rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      getDataFromDatabase(database);
    });
  }

  /// update data in database
  void updateDatabase(String status, int id) async {
    await database.rawUpdate(
        'UPDATE tasks SET notes = ? WHERE id = ?', 
        [status, id]).then((value) {
      getDataFromDatabase(database);
    });
  }
}
