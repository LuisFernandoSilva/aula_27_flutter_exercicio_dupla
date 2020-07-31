import 'package:aula_27_flutter_exercicio_dupla/bd/bd.dart';
import 'package:aula_27_flutter_exercicio_dupla/entities/user.dart';
import 'package:dio/dio.dart';
import 'package:email_validator/email_validator.dart';
import 'package:cnpj_cpf_helper/cnpj_cpf_helper.dart';
import 'package:cnpj_cpf_formatter/cnpj_cpf_formatter.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  static String routeName = '/register_page';
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _cpfController = TextEditingController();
  final _cepController = TextEditingController();
  final _streetController = TextEditingController();
  final _numberHouseController = TextEditingController();
  final _neighborhoodController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  String _country = 'Brasil';
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  User _user = User();
  final userRepository = ProductRepository(Db());

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _cpfController.dispose();
    _cepController.dispose();
    _streetController.dispose();
    _numberHouseController.dispose();
    _neighborhoodController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    super.dispose();
  }

  void _restart() {
    _formKey.currentState.reset();
    _nameController.clear();
    _emailController.clear();
    _cpfController.clear();
    _cepController.clear();
    _streetController.clear();
    _numberHouseController.clear();
    _neighborhoodController.clear();
    _cityController.clear();
    _stateController.clear();
  }

  void _buscaCep(String cep) async {
    var dio = Dio();
    try {
      var response = await dio.get('https://viacep.com.br/ws/$cep/json');
      var address = response.data;
      _streetController.text = address['logradouro'];
      _neighborhoodController.text = address['bairro'];
      _cityController.text = address['localidade'];
      _stateController.text = address['uf'];
    } catch (e) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text("Cep invalido!"),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          title: Text('Cadastro de usuario'),
          centerTitle: true,
          backgroundColor: Colors.red),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 8),
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Nome',
                          hintStyle: TextStyle(color: Colors.blue),
                          focusColor: Colors.red,
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Nome Vazio';
                          }
                          if (value.length <= 3) {
                            return 'Nome muito curto';
                          }
                          if (value.length >= 30) {
                            return 'Nome muito longo';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          _user.name = newValue;
                        },
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'email',
                            hintStyle: TextStyle(color: Colors.blue)),
                        validator: (value) {
                          final bool isValid = EmailValidator.validate(value);
                          if (!isValid) {
                            return 'inválido';
                          }
                          return null;
                        },
                        onFieldSubmitted: (value) {
                          setState(() {});
                        },
                        onSaved: (newValue) {
                          user.email = newValue;
                        },
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        controller: _cpfController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'CPF',
                          hintStyle: TextStyle(color: Colors.blue),
                        ),
                        inputFormatters: [
                          CnpjCpfFormatter(
                            eDocumentType: EDocumentType.CPF,
                          )
                        ],
                        validator: (value) {
                          if (!CnpjCpfBase.isCpfValid(value)) {
                            return 'Não é valido';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          user.cpf = newValue;
                        },
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 50,
                            child: TextFormField(
                              controller: _cepController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Cep',
                                  hintStyle: TextStyle(color: Colors.blue)),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'CEP Vazio';
                                }
                                if (value.length < 8) {
                                  return 'Falta numeros, o correto é 8 números';
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                user.address.cep = newValue;
                              },
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            flex: 25,
                            child: RaisedButton.icon(
                              icon: Icon(Icons.search),
                              onPressed: () {
                                _buscaCep(_cepController.text);
                              },
                              label: Text('buscar'),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 75,
                            child: TextFormField(
                              controller: _streetController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Rua',
                                  hintStyle: TextStyle(color: Colors.blue)),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Rua está Vazio';
                                }
                                if (value.length < 3) {
                                  return 'Endereço muito curto';
                                }
                                if (value.length >= 30) {
                                  return 'Endereço digitado muito longo';
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                user.address.street = newValue;
                              },
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            flex: 25,
                            child: TextFormField(
                              controller: _numberHouseController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Numero',
                                  hintStyle: TextStyle(color: Colors.blue)),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Numero esta Vazio';
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                user.address.numberHouse = newValue;
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 50,
                            child: TextFormField(
                              controller: _neighborhoodController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Bairro',
                                  hintStyle: TextStyle(color: Colors.blue)),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Bairro esta Vazio';
                                }
                                if (value.length >= 30) {
                                  return 'Nome do bairro muito grande';
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                user.address.neighborhood = newValue;
                              },
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            flex: 50,
                            child: TextFormField(
                              controller: _cityController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Cidade',
                                  hintStyle: TextStyle(color: Colors.blue)),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Cidade está Vazio';
                                }
                                if (value.length >= 30) {
                                  return 'Nome da cidade muito grande';
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                user.address.city = newValue;
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 25,
                            child: TextFormField(
                              controller: _stateController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Estado',
                                hintStyle: TextStyle(color: Colors.blue),
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Estado está Vazio';
                                }
                                if (value.length >= 3) {
                                  return 'UF do estado deve ser 2 siglas';
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                user.address.state = newValue;
                              },
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            flex: 75,
                            child: TextFormField(
                              enabled: false,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'País',
                                  hintStyle: TextStyle(color: Colors.blue),
                                  labelText: _country),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 40,
                  child: OutlineButton(
                    onPressed: () {
                      _restart();
                    },
                    child: Text('Limpar'),
                    borderSide: BorderSide(color: Colors.black),
                    focusColor: Colors.red,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  flex: 60,
                  child: OutlineButton(
                    child: Text('Cadastrar'),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        _onSucess();
                        _dialogInfo();
                      }
                    },
                    borderSide: BorderSide(color: Colors.black),
                    focusColor: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

//caixa de dialogo quando termina o cadastro
  void _dialogInfo() {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text(
              'Dados: ${user.name}',
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text(
                    'ok',
                  ))
            ],
            content: Text('Nome:\n${user.name}\n'
                'Email:\n ${user.email}\n'
                'Cpf:\n ${user.cpf}\n'
                'Endereço:\n'
                'Rua: ${user.address.street},Numero: ${user.address.numberHouse},\n'
                'Bairro: ${user.address.neighborhood},Cidade: ${user.address.city}\n'
                'País: $_country\n'),
          );
        });
  }

  void _onSucess() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Usuario Criado com sucesso!"),
      backgroundColor: Colors.red,
      duration: Duration(seconds: 3),
    ));
  }
}
