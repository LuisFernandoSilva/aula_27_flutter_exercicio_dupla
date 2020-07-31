import 'package:aula_27_flutter_exercicio_dupla/pages/home_page.dart';
import 'package:aula_27_flutter_exercicio_dupla/pages/register_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: HomePage.routeName,
        routes: {
          HomePage.routeName: (ctx) {
            return HomePage();
          },
          RegisterPage.routeName: (ctx) {
            return RegisterPage();
          }
        });
  }
}
