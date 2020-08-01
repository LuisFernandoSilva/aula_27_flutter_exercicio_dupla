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

  @override
  void initState() {
    super.initState();
    repository = UserRepository(Db());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          //TODO aqui vem um desafio, o evandro fez um dismissible, que guarda por
          // 5 segundos os dados que seriam deletados, e fez um snackbar com um aviso
          // que seria deletado o cadastro e colocou um botao de desfazer que se a pessoa
          // tocar nesse botao desfaz a acao de deletar e o cadastro volta rpo listview.
          //acredito que a logica disso seja ! ele guarda os dados em um list normal e quando acaba o tempo do snack bar
          //dai sim ele deleta do banco e botao de desfazer e so pra sair da contagem do snackbar!
          // com isso acho que vai ficar show

          return Padding(
            padding: const EdgeInsets.all(8),
            child: ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.startToEnd,
                  confirmDismiss: (direction) async {
                    return repository.deleteUser(snapshot.data[index].id);
                  },
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
