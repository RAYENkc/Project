import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  //final String uid;
  final String nom;
  final String prenom;
  final int age;
  final String profession;
  final String role;
  final String niveaux;
  final String id;
  final String email;
  final String tel;
  final String photo;
  final String photoCov;
  final String description;

  User({
    required this.photo,
    required this.photoCov,
    required this.nom,
    required this.prenom,
    required this.age,
    required this.profession,
    required this.role,
    required this.niveaux,
    required this.id,
    required this.email,
    required this.tel,
    required this.description,
  });

  factory User.fromJson(DocumentSnapshot json) {
    print(json['nom']);
    print(json['prenom']);

    print(json['profession']);

    print(json['email']);
    print(json['description']);
    print(json['tel']);
    return User(
        nom: json['nom'],
        prenom: json['prenom'],
        age: json['age'],
        profession: json['profession'],
        role: json['role'],
        niveaux: json['niveaux'],
        id: json['id'],
        description: json['description'],
        email: json['email'],
        tel: json['tel'],
        photo: json['photo'],
        photoCov: json['photoCov']);
  }
}
