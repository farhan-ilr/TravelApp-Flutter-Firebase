import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travel_app/Models-and-Functions/packag_meodel.dart';
import 'package:travel_app/Models-and-Functions/user_model.dart';
import 'package:travel_app/main.dart';
import 'package:uuid/uuid.dart';

class AddPackages extends StatefulWidget {
  final UserModel thisAgency;
  final User firebaseAgency;

  const AddPackages(
      {super.key, required this.thisAgency, required this.firebaseAgency});

  @override
  State<AddPackages> createState() => _AddPackagesState();
}

class _AddPackagesState extends State<AddPackages> {
  TextEditingController packagenameController = TextEditingController();
  TextEditingController packageCostController = TextEditingController();
  TextEditingController packageDescriptionController = TextEditingController();
  TextEditingController packageDaysController = TextEditingController();

  File? imageFile;
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
        IOSUiSettings(
          title: 'Cropper',
        ),
        WebUiSettings(
          context: context,
          presentStyle: CropperPresentStyle.dialog,
          boundary: const CroppieBoundary(
            width: 520,
            height: 520,
          ),
          viewPort:
              const CroppieViewPort(width: 480, height: 480, type: 'circle'),
          enableExif: true,
          enableZoom: true,
          showZoomer: true,
        ),
      ],
    );

    if (croppedimage != null) {
      setState(() {
        imageFile = File(croppedimage.path);
      });
    }
  }

  void showPhotoOptions() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Upload Image"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  selectImages(ImageSource.gallery);
                },
                title: const Text("Select From Gallery"),
                leading: const Icon(Icons.browse_gallery),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  selectImages(ImageSource.camera);
                },
                title: const Text("Take a Photo"),
                leading: const Icon(Icons.camera_enhance),
              )
            ],
          ),
        );
      },
    );
  }

  void checkValues() {
    String pName = packagenameController.text.trim();
    String pCost = packageCostController.text.trim();
    String pDesc = packageDescriptionController.text.trim();
    String pDays = packageDaysController.text.trim();

    if (imageFile == null ||
        pName == "" ||
        pCost == "" ||
        pDesc == "" ||
        pDays == "" ||
        pDesc.length < 15) {
      const errorSnackBar =
          SnackBar(content: Text("Please Fill All The Fields"));

      ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
    }
  }

  void uploadData() async {
    String id = const Uuid().v1();
    UploadTask uploadTask = FirebaseStorage.instance
        .ref("travelPackageImags")
        .child(id)
        .putFile(imageFile!);

    TaskSnapshot snapshot = await uploadTask;

    String imageUrl = await snapshot.ref.getDownloadURL();
    PackageModel newPackage = PackageModel(
      packageId: id,
      agencyId: widget.firebaseAgency.uid,
      agencyName: widget.thisAgency.username,
      packageName: packagenameController.text.trim(),
      days: packageDaysController.text.trim(),
      description: packageDescriptionController.text.trim(),
      imageOfPlace: imageUrl,
      cost: packageCostController.text.trim(),
    );
    await ctrl.db.collection("packages").doc(id).set(newPackage.toMap());
    const errorSnackBar = SnackBar(content: Text("Data Added "));

    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(25),
        child: ListView(
          children: [
            Center(
              child: CupertinoButton(
                onPressed: () {
                  showPhotoOptions();
                },
                child: CircleAvatar(
                  radius: 75,
                  backgroundImage:
                      (imageFile != null) ? FileImage(imageFile!) : null,
                  child: (imageFile == null)
                      ? const Icon(Icons.add_a_photo)
                      : null,
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            TextField(
              controller: packagenameController,
              decoration: const InputDecoration(hintText: "Package Name "),
            ),
            const SizedBox(
              height: 15,
            ),
            TextField(
              controller: packageCostController,
              decoration: const InputDecoration(hintText: "Cost"),
            ),
            const SizedBox(
              height: 15,
            ),
            TextField(
              maxLines: null,
              controller: packageDescriptionController,
              decoration: const InputDecoration(hintText: "Description"),
            ),
            const SizedBox(
              height: 15,
            ),
            TextField(
              controller: packageDaysController,
              decoration: const InputDecoration(hintText: "days ..."),
            ),
            const SizedBox(
              height: 15,
            ),
            CupertinoButton(
              onPressed: () {
                checkValues();
                uploadData();
              },
              color: Theme.of(context).colorScheme.secondary,
              child: const Text("Add "),
            )
          ],
        ));
  }
}
