import 'package:aula_27_flutter_exercicio_dupla/bd/bd.dart';
import 'package:aula_27_flutter_exercicio_dupla/entities/user.dart';
import 'package:aula_27_flutter_exercicio_dupla/pages/register_page.dart';
import 'package:aula_27_flutter_exercicio_dupla/repository/user_repository.dart';
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushNamed(HomePage.routeName);
          },
        ),
      ),
      body: FutureBuilder<List<User>>(
        future: repository.getUsers(),
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
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(RegisterPage.routeName,
                        arguments: snapshot.data[index]);
                  },
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
          }),
    );
  }
}
