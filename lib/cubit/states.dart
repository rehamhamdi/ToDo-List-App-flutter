abstract class AppStates{}

class AppInitialState extends AppStates{}
class AppGetDatabaseSuccessState extends AppStates{}
class AppInsertDatabaseSuccessState extends AppStates{}
class AppInsertDatabaseErrorState extends AppStates{
  final String error;

  AppInsertDatabaseErrorState(this.error);
  }

