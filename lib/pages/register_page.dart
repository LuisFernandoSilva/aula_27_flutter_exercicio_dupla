import 'package:aula_27_flutter_exercicio_dupla/bd/bd.dart';
import 'package:aula_27_flutter_exercicio_dupla/entities/user.dart';
import 'package:aula_27_flutter_exercicio_dupla/pages/home_page.dart';
import 'package:aula_27_flutter_exercicio_dupla/repository/user_reposito.dart';
import 'package:aula_27_flutter_exercicio_dupla/repository/user_repository.dart';
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
  TextEditingController _nameController;
  TextEditingController _emailController;
  TextEditingController _cpfController;
  TextEditingController _cepController;
  TextEditingController _streetController;
  TextEditingController _numberHouseController;
  TextEditingController _neighborhoodController;
  TextEditingController _cityController;
  TextEditingController _stateController;
  TextEditingController _countryController;
  String _country = 'Brasil';
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  bool edit = false;
  User _user = User();
  final userRepository = UserReposito(Db());

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final user = ModalRoute.of(context).settings.arguments as User;
    if (user == null) {
      edit = true;
    }

    _nameController = TextEditingController(text: user?.name ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _cpfController = TextEditingController(text: user?.cpf ?? '');
    _cepController = TextEditingController(text: user?.cep ?? '');
    _streetController = TextEditingController(text: user?.street ?? '');
    _numberHouseController =
        TextEditingController(text: user?.numberHouse ?? '');
    _neighborhoodController =
        TextEditingController(text: user?.neighborhood ?? '');
    _cityController = TextEditingController(text: user?.city ?? '');
    _stateController = TextEditingController(text: user?.state ?? '');
    _countryController = TextEditingController(text: user?.country ?? '');
    /* _country = user?.country ?? ''; */
    /*  _user.name = user?.name ?? null; */
    _user.id = user?.id ?? null;
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
                          _user.email = newValue;
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
                          _user.cpf = newValue;
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
                                _user.cep = newValue;
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
                                _user.street = newValue;
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
                                _user.numberHouse = newValue;
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
                                _user.neighborhood = newValue;
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
                                _user.city = newValue;
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
                                _user.state = newValue;
                              },
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            flex: 75,
                            child: TextFormField(
                              controller: _countryController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'País',
                                  hintStyle: TextStyle(color: Colors.blue),
                                  labelText: _country),
                              onSaved: (newValue) {
                                _user.country = newValue;
                              },
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
                edit
                    ? Expanded(
                        flex: 60,
                        child: OutlineButton(
                          child: Text('Cadastrar'),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              _saveUser();
                            }
                          },
                          borderSide: BorderSide(color: Colors.black),
                          focusColor: Colors.red,
                        ),
                      )
                    : Expanded(
                        flex: 60,
                        child: OutlineButton(
                          child: Text('Editar'),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              _updateUser();
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

  void _saveUser() async {
    final saved = await userRepository.saveUser(_user);

    userRepository.recoverUser();

    if (!saved) {
      _showSnackBar("Usuario Criado com sucesso!");
      return;
    }
    Navigator.of(context).pushNamed(HomePage.routeName);
  }

  void _updateUser() async {
    final update = await userRepository.updateUser(_user);
    if (!update) {
      _showSnackBar('Não foi possível atualizar a tarefa!');
      return;
    }
    Navigator.of(context).pushNamed(HomePage.routeName);
  }

  void _showSnackBar(String text) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(text),
      backgroundColor: Colors.red,
      duration: Duration(seconds: 3),
    ));
    Navigator.of(context).pushNamed(HomePage.routeName);
  }
}
