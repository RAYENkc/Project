import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:project_profil/ProfilPic.dart';
import 'package:project_profil/body.dart';
import 'package:project_profil/model/users.dart';
import 'package:project_profil/widget/appbar_widget.dart';
import 'package:project_profil/widget/profile_widget.dart';
import 'package:project_profil/widget/textfield_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfilePage extends StatefulWidget {
  final String currentId;
  const EditProfilePage({Key? key, required this.currentId}) : super(key: key);
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  //User user = UserPreferences.myUser;

  TextEditingController _prenomController = TextEditingController();
  TextEditingController _nomController = TextEditingController();
  TextEditingController _professionController = TextEditingController();
  TextEditingController _telController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  TextEditingController _ageController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return Builder(
      builder: (context) => Scaffold(
        appBar: buildAppBar(context),
        body: FutureBuilder<DocumentSnapshot>(
            future: users.doc("oH5KmesriWP1MAhwef6P").get(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return Center(child: CircularProgressIndicator());
              }
              Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;

              _nomController.text = data['nom'];
              _prenomController.text = data['prenom'];
              _professionController.text = data['profession'];
              _telController.text = data['tel'].toString();
              _emailController.text = data['email'];
              _ageController.text = data['age'].toString();
              _descriptionController.text = data['description'];

              print("11111111111111111111111111");
              print(data);

              print("222222222222222222222222222222222222222222222");

              return ListView(
                padding: EdgeInsets.symmetric(horizontal: 32),
                physics: BouncingScrollPhysics(),
                children: [
                  ProfilePic(currentId: widget.currentId),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'nom',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _nomController,
                        decoration: InputDecoration(
                          //  hintText: ,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        maxLines: 1,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Prenom',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _prenomController,
                        decoration: InputDecoration(
                          //  hintText: ,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        maxLines: 1,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Profession',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _professionController,
                        decoration: InputDecoration(
                          //  hintText: ,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        maxLines: 1,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tel',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _telController,
                        decoration: InputDecoration(
                          //  hintText: ,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        maxLines: 1,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Email',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          //  hintText: ,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        maxLines: 1,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Age',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _ageController,
                        decoration: InputDecoration(
                          //  hintText: ,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        maxLines: 1,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Description',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          //  hintText: ,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        maxLines: 3,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Material(
                      color: Colors.orange[900],
                      elevation: 6.0,
                      borderRadius: BorderRadius.circular(50),
                      child: MaterialButton(
                        onPressed: () {
                          print("vvvvvvvv");
                          print(_nomController.text);

                          users
                              .doc('oH5KmesriWP1MAhwef6P')
                              .update({
                                'nom': _nomController.text,
                                'prenom': _prenomController.text,
                                'age': _ageController.text,
                                'email': _emailController.text,
                                'tel': _telController.text,
                                'description': _descriptionController.text,
                                'profession': _professionController.text
                              })
                              .then((value) => print("User Updated"))
                              .catchError((error) =>
                                  print("Failed to update user: $error"));

                          /*   Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Body()));*/
                        },
                        minWidth: 130.0,
                        height: 60.0,
                        child: Text("valider",
                            style: TextStyle(color: Colors.white)),
                      ))
                ],
              );
            }),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final VoidCallback callback;
  final String text;

  const CustomButton(Key key, this.callback, this.text) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50),
      height: 50,
      padding: const EdgeInsets.all(0.6),
      child: Material(
          color: Colors.orange[900],
          elevation: 6.0,
          borderRadius: BorderRadius.circular(50),
          child: MaterialButton(
            onPressed: callback,
            minWidth: 130.0,
            height: 60.0,
            child: Text(text, style: TextStyle(color: Colors.white)),
          )),
    );
  }
}
