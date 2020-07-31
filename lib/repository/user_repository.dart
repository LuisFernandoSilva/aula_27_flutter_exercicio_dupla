import 'package:aula_27_flutter_exercicio_dupla/bd/bd.dart';
import 'package:aula_27_flutter_exercicio_dupla/entities/user.dart';

class UserRepository {
  final Db _dbHelper;
  UserRepository(this._dbHelper);

  Future<bool> newUser(User obj) async {
    var db = await _dbHelper.recoverInstance();
    var rows = await db.insert('user', obj.toMap());
    return rows > 0;
  }

  Future<bool> updateUser(User obj) async {
    var db = await _dbHelper.recoverInstance();
    var rows = await db
        .update('user', obj.toMap(), where: 'id = ?', whereArgs: [obj.id]);
    return rows > 0;
  }

  Future<bool> deleteUser(User obj) async {
    var db = await _dbHelper.recoverInstance();
    var rows = await db.delete(
      'user',
      where: 'id = ?',
      whereArgs: [obj.id],
    );
    return rows > 0;
  }

  Future<List<User>> getUsers() async {
    var retorno = <User>[];
    var db = await _dbHelper.recoverInstance();
    var result = await db.query('user');
    if (result.isNotEmpty) {
      for (var user in result) {
        retorno.add(User.fromMap(user));
      }
    }
    return retorno ?? [];
  }
}
