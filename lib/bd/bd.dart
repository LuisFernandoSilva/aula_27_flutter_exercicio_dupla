import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Db {
  Database _instance;

  static final Db _dataBase = Db._internal();
  Db._internal();
  //cria uma instancia da classe apenas uma vez
  factory Db() {
    return _dataBase;
  }
  //recupera o valor da instancia que foi criada no factory para ser usada
  Future<Database> recoverInstance() async {
    if (_instance == null) {
      _instance = await _openDB();
    }
    return _instance;
  }

  //cria as tabelas no banco de dados, se nao houver uma tabela cria uma
  Future<Database> _openDB() async {
    final pathdataBase = await getDatabasesPath();
    final db = await openDatabase(
      join(pathdataBase, 'user.db'),
      onCreate: (db, version) {
        return db.execute('''
        create table user(
          id integer primary key autoincrement,
          name text,
          email text,
          cpf text,  
          cep text,
          street text,
          numberHouse text,
          neighborhood text,
          state text,
          city text,
          country text

        )
        ''');
      },
      version: 1,
    );
    return db;
  }
}
