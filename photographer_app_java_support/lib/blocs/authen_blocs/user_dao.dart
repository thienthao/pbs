import 'package:photographer_app_java_support/blocs/authen_blocs/sqlite_provider.dart';
import 'package:photographer_app_java_support/blocs/authen_blocs/user_model.dart';

class UserDao {
  final sqProvider = SQLiteProvider.sqLiteProvider;

  Future<int> createUser(User user) async {
    final db = await sqProvider.database;

    var result = db.insert(userTable, user.toDatabaseJson());
    return result;
  }

  Future<int> deleteUser(int id) async {
    final db = await sqProvider.database;
    var result = await db.delete(userTable, where: "id = ?", whereArgs: [id]);
    return result;
  }

  Future<int> getUserId() async {
    final db = await sqProvider.database;
    List<Map> users = await db.query(userTable);
    var result = users[0]["id"];
    return result;
  }

  Future<String> getUsername() async {
    final db = await sqProvider.database;
    List<Map> users = await db.query(userTable);
    var result = users[0]["username"];
    return result;
  }

  Future<String> getUserToken() async {
    final db = await sqProvider.database;
    List<Map> users = await db.query(userTable);
    var result = users[0]["accessToken"];
    return result;
  }

  Future<bool> checkUser(int id) async {
    final db = await sqProvider.database;
    try {
      List<Map> users =
          await db.query(userTable, where: 'id = ?', whereArgs: [id]);
      if (users.length > 0) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }
}
