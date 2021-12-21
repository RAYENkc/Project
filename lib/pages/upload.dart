import 'dart:io' as i;
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';

import 'package:image_picker/image_picker.dart';
import 'package:project_profil/Custom_Botton_Nav_Bar.dart';
import 'package:project_profil/enums.dart';
import 'package:project_profil/main.dart';
import 'package:project_profil/model/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Im;
import 'package:project_profil/welcome/Login/components/body.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image/src/formats/formats.dart';
import 'package:geocoding/geocoding.dart';

class Upload extends StatefulWidget {
  // final User currentUser;

  // Upload({required this.currentUser});

  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload>
    with AutomaticKeepAliveClientMixin<Upload> {
  TextEditingController LocationController = TextEditingController();
  TextEditingController captionController = TextEditingController();
  TextEditingController ProblemController = TextEditingController();
  var file;
  var user;
  var imagePicker;
  bool isUploading = false;
  String postId = Uuid().v4();

  @override
  void initState() {
    super.initState();
    getUser();
    imagePicker = new ImagePicker();
  }

  getUser() async {
    final String id = "oH5KmesriWP1MAhwef6P";
    final DocumentSnapshot doc = await usersRef.doc(id).get();
    //   .then((DocumentSnapshot doc) => {
    /*print("doc.data()doc.data()doc.data()doc.data()doc.data()doc.data()");
    print(doc.data());*/
    user = doc.data();
  }

  handleTakePhoto() async {
    Navigator.pop(context);

    XFile file = await imagePicker.pickImage(
      source: ImageSource.camera,
      maxHeight: 67,
      maxWidth: 960,
    );

    setState(() {
      if (mounted) this.file = File(file.path);
    });
  }

  handleChosseFromGallery() async {
    Navigator.pop(context);
    XFile file = await imagePicker.pickImage(source: ImageSource.gallery);
    print("filefilefile");
    print(File(file.path));

    setState(() {
      this.file = File(file.path);
    });
  }

  selectImage(parentcontext) {
    return showDialog(
        context: parentcontext,
        builder: (context) {
          return SimpleDialog(
            title: Text("Create Post"),
            children: [
              SimpleDialogOption(
                child: Text("Photo with Camera"),
                onPressed: handleTakePhoto,
              ),
              SimpleDialogOption(
                child: Text("Image from Gallery"),
                onPressed: handleChosseFromGallery,
              ),
              SimpleDialogOption(
                child: Text("Cancel"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }

  Container buildSplashScreen() {
    return Container(
      color: Theme.of(context).accentColor.withOpacity(0.6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SvgPicture.asset(
            'assets/images/upload.svg',
            height: 260.0,
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                onPressed: () => selectImage(context),
                child: Text(
                  "Upload Image",
                  style: TextStyle(color: Colors.white, fontSize: 22.0),
                ),
                color: Colors.deepOrange),
          )
        ],
      ),
    );
  }

  clearImage() {
    setState(() {
      file = null;
    });
  }

  compressImage() async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    print("filefilefile22222222222222222");
    print(file);
    Im.Image? imageFile = Im.decodeImage(file.readAsBytesSync());

    /*final compressedImageFile = new File('$path/img_$postId.jpg')
      ..writeAsBytesSync(Im.encodeJpg(imageFile, quality: 85));
 setState(() {
      file = compressedImageFile;
    });*/
  }

  Future<String> uploadImage(imageFile) async {
    print("filefilefile11111111111111");
    print(file);
    UploadTask uploadTask = ref.ref("post_$postId.jpg").putFile(imageFile);
    TaskSnapshot storageSnap = await uploadTask.whenComplete(() {});
    final urlDownload = await storageSnap.ref.getDownloadURL();
    print('Download-link: $urlDownload');
    return urlDownload;
  }

  createPostInfirestore(
      {required String mediaUrl,
      required String location,
      required String description}) {
    postsRef.doc(user['id']).collection("users").doc(postId).set({
      "postId": postId,
      "ownerId": user['id'],
      "username": user['nom'],
      "mediaUrl": mediaUrl,
      "description": description,
      "location": location,
      "problemType": ProblemController.text,
      "timestamp": timestamp,
      "likes": {}
    });
    timelineRef.doc().collection("users").doc(postId).set({
      "postId": postId,
      "ownerId": user['id'],
      "username": user['nom'],
      "mediaUrl": mediaUrl,
      "description": description,
      "location": location,
      "problemType": ProblemController.text,
      "timestamp": timestamp,
      "likes": {}
    });
  }

  handleSubmit() async {
    setState(() {
      isUploading = true;
    });

    //await compressImage();
    String mediaUrl = await uploadImage(file);
    createPostInfirestore(
        mediaUrl: mediaUrl,
        location: LocationController.text,
        description: captionController.text);

    captionController.clear();
    LocationController.clear();
    setState(() {
      file = null;
      isUploading = false;
      postId = Uuid().v4();
    });
  }

  Scaffold buildUploadForm() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        leading: IconButton(
          onPressed: clearImage,
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title: Text("Caption Post", style: TextStyle(color: Colors.black)),
        actions: [
          FlatButton(
              onPressed: isUploading ? null : () => handleSubmit(),
              child: Text(
                'Post',
                style: TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0),
              ))
        ],
      ),
      body: ListView(
        children: [
          isUploading ? LinearProgressIndicator() : Text(""),
          Container(
            height: 220.0,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: FileImage(file),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 10.0)),
          ListTile(
            leading: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(user['photo']),
            ),
            title: Container(
              width: 250.0,
              child: TextField(
                controller: captionController,
                decoration: InputDecoration(
                    hintText: "Write a caption ....", border: InputBorder.none),
              ),
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.poll_sharp, color: Colors.orange, size: 35.0),
            title: Container(
              width: 250.0,
              child: TextField(
                controller: ProblemController,
                decoration: InputDecoration(
                    hintText: "type of problem....", border: InputBorder.none),
              ),
            ),
          ),
          Divider(),
          ListTile(
              leading: Icon(Icons.pin_drop, color: Colors.orange, size: 35.0),
              title: Container(
                  width: 250.0,
                  child: TextField(
                    controller: LocationController,
                    decoration: InputDecoration(
                        hintText: "Where was this photo taken?",
                        border: InputBorder.none),
                  ))),
          Container(
            width: 200.0,
            height: 100.0,
            alignment: Alignment.center,
            child: RaisedButton.icon(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
                label: Text(
                  "Use Current Location",
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.blue,
                onPressed: getUserLocation,
                icon: Icon(
                  Icons.my_location,
                  color: Colors.white,
                )),
          )
        ],
      ),
    );
  }

  getUserLocation() async {
    print(
        "placemarkplacemarkplacemarkplacemarkplacemarkplacemarkplacemarkplacemarkplacemarkplacemarkplacemarkplacemarkplacemarkplacemarkplacemark");
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(position.longitude);

    /* List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark placemark = placemarks[0];
    print(placemark);
    String formattedAddress = "${placemark.locality},${placemark.country}";
    LocationController.text = formattedAddress;*/
  }

  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      bottomNavigationBar: CustomBottonNavBar(
        selectedMenu: MenuState.search,
        currentId: currentId,
      ),
      body: file == null ? buildSplashScreen() : buildUploadForm(),
    );
  }
}
