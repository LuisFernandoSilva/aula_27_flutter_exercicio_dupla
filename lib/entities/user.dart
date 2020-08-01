class User {
  int id;
  String name;
  String email;
  String cpf;
  String cep;
  String street;
  String numberHouse;
  String neighborhood;
  String city;
  String state;
  String country = 'Brasil';

  User(
      {this.id,
      this.name,
      this.email,
      this.cpf,
      this.cep,
      this.street,
      this.numberHouse,
      this.neighborhood,
      this.city,
      this.state,
      this.country});

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      cpf: map['cpf'],
      cep: map['cep'],
      street: map['street'],
      numberHouse: map['numberHouse'],
      neighborhood: map['neighborhood'],
      city: map['city'],
      state: map['state'],
      country: map['country'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'cpf': cpf,
      'cep': cep,
      'street': street,
      'numberHouse': numberHouse,
      'neighborhood': neighborhood,
      'city': city,
      'state': state,
      'country': country,
    };
  }
}
