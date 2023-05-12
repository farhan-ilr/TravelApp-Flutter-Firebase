import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travel_app/Models-and-Functions/user_model.dart';
import 'package:travel_app/admin&trave_agency/agency/agency_home.dart';
import 'package:travel_app/main.dart';
import 'package:travel_app/screens/home/home_screen.dart';

class EditProfile extends StatefulWidget {
  final UserModel thisUser;
  const EditProfile({required this.thisUser, super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController bioController = TextEditingController();
  File? imageFile;
  String? imageUrl = "";
  bool imageAvailable = true;

  @override
  void initState() {
    bioController.text = widget.thisUser.bio.toString();
    imageUrl = widget.thisUser.profilePic.toString();
    super.initState();
  }

  void selectImages(ImageSource source) async {
    XFile? pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      cropImage(pickedFile);
    }
  }

  void cropImage(XFile file) async {
    CroppedFile? croppedimage = await ImageCropper().cropImage(
        sourcePath: file.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 20,
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(title: 'Cropper'),
          WebUiSettings(
              context: context,
              presentStyle: CropperPresentStyle.dialog,
              boundary: const CroppieBoundary(width: 520, height: 520),
              viewPort: const CroppieViewPort(
                  width: 480, height: 480, type: 'circle'),
              enableExif: true,
              enableZoom: true,
              showZoomer: true)
        ]);

    if (croppedimage != null) {
      setState(() {
        imageFile = File(croppedimage.path);
        imageAvailable = false;
      });
    }
  }

  void showPhotoOptions() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: const Text("Upload Image"),
              content: Column(mainAxisSize: MainAxisSize.min, children: [
                ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      selectImages(ImageSource.gallery);
                    },
                    title: const Text("Select From Gallery"),
                    leading: const Icon(Icons.browse_gallery)),
                ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      selectImages(ImageSource.camera);
                    },
                    title: const Text("Take a Photo"),
                    leading: const Icon(Icons.camera_enhance))
              ]));
        });
  }

  void checkValues() {
    String bioText = bioController.text.trim();
    if (imageFile == null && bioText == "") {
      const errorSnackBar =
          SnackBar(content: Text("Please Fill Any One Fields"));
      ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
    }
  }

  uploadData() async {
    if (imageFile != null) {
      UploadTask uploadTask = FirebaseStorage.instance
          .ref("profilepics")
          .child(widget.thisUser.id.toString())
          .putFile(imageFile!);
      TaskSnapshot snapshot = await uploadTask;
      imageUrl = await snapshot.ref.getDownloadURL();
    }
    UserModel editedUser = UserModel(
      id: widget.thisUser.id.toString(),
      username: widget.thisUser.username.toString(),
      email: widget.thisUser.email.toString(),
      type: widget.thisUser.type.toString(),
      profilePic: imageUrl ?? widget.thisUser.profilePic.toString(),
      bio: bioController.text.toString(),
    );
    try {
      await ctrl.db
          .collection("Users")
          .doc(widget.thisUser.id.toString())
          .set(editedUser.toMap());
      const sucessSnackbar = SnackBar(content: Text("Data Updated "));
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(sucessSnackbar);
    } catch (e) {
      const errorSnackBar = SnackBar(content: Text("Data Updating Failed "));
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Edit profile"),
        ),
        body: SafeArea(
            child: Container(
                margin: const EdgeInsets.only(top: 50),
                padding: const EdgeInsets.only(left: 35, right: 35),
                child: ListView(children: [
                  Center(
                      child: CupertinoButton(
                          onPressed: () {
                            showPhotoOptions();
                          },
                          child: imageAvailable == true
                              ? CircleAvatar(
                                  radius: 75,
                                  backgroundImage: (widget.thisUser.profilePic
                                              .toString() ==
                                          "noImage")
                                      ? const NetworkImage(
                                          "https://cdn-icons-png.flaticon.com/512/149/149071.png")
                                      : NetworkImage(imageUrl.toString()),
                                  child: (imageFile == null)
                                      ? const Icon(Icons.add_a_photo_outlined)
                                      : null)
                              : CircleAvatar(
                                  radius: 75,
                                  backgroundImage: (imageFile != null)
                                      ? FileImage(imageFile!)
                                      : null,
                                  child: (imageFile == null)
                                      ? const Icon(Icons.add_a_photo)
                                      : null,
                                ))),
                  const SizedBox(height: 25),
                  TextField(
                    maxLines: null,
                    controller: bioController,
                    decoration: const InputDecoration(hintText: "Bio"),
                  ),
                  const SizedBox(height: 25),
                  CupertinoButton(
                      onPressed: () async {
                        checkValues();
                        await uploadData();
                        setState(() {
                          bioController.clear();
                          imageAvailable = false;
                        });
                        UserModel user =
                            await ctrl.getUserModelById(widget.thisUser.id!);
                        user.type == "user"
                            // ignore: use_build_context_synchronously
                            ? Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (ctx) {
                                return HomeScreen(
                                    thisUserModel: user,
                                    currentUser: ctrl.auth.currentUser!);
                              }))
                            // ignore: use_build_context_synchronously
                            : Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (ctx) {
                                return Agencymainpage(thisAgency: user);
                              }));
                      },
                      color: Theme.of(context).colorScheme.secondary,
                      child: const Text("Update "))
                ]))));
  }
}
