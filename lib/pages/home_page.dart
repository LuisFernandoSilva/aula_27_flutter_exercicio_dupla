import 'package:aula_27_flutter_exercicio_dupla/bd/bd.dart';
import 'package:aula_27_flutter_exercicio_dupla/entities/user.dart';
import 'package:aula_27_flutter_exercicio_dupla/pages/register_page.dart';
import 'package:aula_27_flutter_exercicio_dupla/repository/user_repository.dart';

/* import 'package:aula_27_flutter_exercicio_dupla/repository/user_repository.dart'; */
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static String routeName = '/';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserRepository repository;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    repository = UserRepository(Db());
    /* feito para teste do remove
    repository.saveUser(
      User(
          cep: '9352941',
          city: 'Novo Hamburgo',
          cpf: '01864404051',
          email: 'henrique99caruso@gmail.com',
          country: 'Brasil',
          name: 'Henrique',
          neighborhood: 'Guarani',
          numberHouse: '568',
          state: 'RS',
          street: 'Julio adams'),
    ); */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Tela de cadastros '),
        centerTitle: true,
        backgroundColor: Colors.red,
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<List<User>>(
        future: repository.recoverUser(),
        initialData: null,
        builder: (ctx, snapshot) {
          if (!snapshot.hasData && !snapshot.hasError) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData && snapshot.hasError) {
            return Center(
              child: Text(snapshot.hasError.toString()),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(8),
            child: ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.startToEnd,
                  confirmDismiss: (direction) async => showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                            title: Text('Exluir ${snapshot.data[index].name}'),
                            content: Text(
                                'Isso irá excluir permanentemente esse item.'),
                            actions: [
                              FloatingActionButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Icon(Icons.cancel),
                              ),
                              SizedBox(width: 10),
                              FloatingActionButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    _scaffoldKey.currentState.showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Item excluido com Sucesso.',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        backgroundColor: Colors.red,
                                        duration: Duration(seconds: 3),
                                      ),
                                    );
                                    setState(() {
                                      repository
                                          .deleteUser(snapshot.data[index].id);
                                    });
                                  },
                                  child: Icon(Icons.delete_sweep)),
                            ]);
                      }),
                  background: Container(
                    color: Colors.red,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Removendo...',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  child: GestureDetector(
                    child: ListTile(
                      leading: Icon(
                        Icons.person,
                        color: Colors.teal,
                        size: 40,
                      ),
                      title: Text('${snapshot.data[index].name}'),
                      subtitle: Text('${snapshot.data[index].toString()}'),
                      isThreeLine: true,
                    ),
                    onTap: () {
                      Navigator.of(context).pushNamed(RegisterPage.routeName,
                          arguments: snapshot.data[index]);
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).pushNamed(RegisterPage.routeName);
            setState(() {});
          }),
    );
  }
}
