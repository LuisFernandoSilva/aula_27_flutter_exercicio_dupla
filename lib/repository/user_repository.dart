import 'package:aula_27_flutter_exercicio_dupla/bd/bd.dart';
import 'package:aula_27_flutter_exercicio_dupla/entities/user.dart';

class UserRepository {
  final Db _db;
  UserRepository(this._db);
  String errorDb;

  Future<bool> saveUser(User user) async {
    try {
      var instanceDB = await _db.recoverInstance();
      var result = await instanceDB.insert('user', user.toMap());
      return result > 0;
    } catch (e) {
      errorDb = e;
      return false;
    }
  }

  Future<bool> updateUser(User user) async {
    try {
      var instanceDB = await _db.recoverInstance();
      var result = await instanceDB
          .update('user', user.toMap(), where: 'id = ?', whereArgs: [user.id]);

      return result > 0;
    } catch (e) {
      errorDb = e;
      return false;
    }
  }

  Future<bool> deleteUser(int id) async {
    try {
      var instanceDB = await _db.recoverInstance();
      var result =
          await instanceDB.delete('user', where: 'id = ?', whereArgs: [id]);

      return result > 0;
    } catch (e) {
      errorDb = e;
      return false;
    }
  }

  Future<List<User>> recoverUser() async {
    try {
      /* await Future.delayed(Duration(seconds: 3)); */
      var instanceDB = await _db.recoverInstance();
      final result = await instanceDB.query('user');
      var users = result.map((e) => User.fromMap(e))?.toList();

      return users ?? [];
    } catch (e) {
      errorDb = e;
      return e;
    }
  }
}
