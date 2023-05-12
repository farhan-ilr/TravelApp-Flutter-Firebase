import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travel_app/Models-and-Functions/packag_meodel.dart';
import 'package:travel_app/Models-and-Functions/user_model.dart';
import 'package:travel_app/main.dart';

class EditPackages extends StatefulWidget {
  final UserModel thisAgency;
  final PackageModel pmodel;

  const EditPackages(
      {super.key, required this.thisAgency, required this.pmodel});

  @override
  State<EditPackages> createState() => _EditPackagesState();
}

class _EditPackagesState extends State<EditPackages> {
  TextEditingController editnameController = TextEditingController();
  TextEditingController editCostController = TextEditingController();
  TextEditingController editDescriptionController = TextEditingController();
  TextEditingController erditDaysController = TextEditingController();

  File? imageFile;
  String imageUrl = "";
  bool availableImage = true;

  @override
  void initState() {
    imageUrl = widget.pmodel.imageOfPlace!;

    editnameController.text = widget.pmodel.packageName!;
    editCostController.text = widget.pmodel.cost!;
    editDescriptionController.text = widget.pmodel.description!;
    erditDaysController.text = widget.pmodel.days!;
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
      compressQuality: 50,
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
    String pName = editnameController.text.trim();
    String pCost = editCostController.text.trim();
    String pDesc = editDescriptionController.text.trim();
    String pDays = erditDaysController.text.trim();

    if (pName == "" ||
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
    UploadTask uploadTask = FirebaseStorage.instance
        .ref("travelPackageImags")
        .child(widget.pmodel.packageId!)
        .putFile(imageFile!);

    TaskSnapshot snapshot = await uploadTask;

    imageUrl = await snapshot.ref.getDownloadURL();
    PackageModel newPackage = PackageModel(
      packageId: widget.pmodel.packageId!,
      agencyId: widget.pmodel.agencyId,
      agencyName: widget.thisAgency.username,
      packageName: editnameController.text.trim(),
      days: erditDaysController.text.trim(),
      description: editDescriptionController.text.trim(),
      imageOfPlace: imageUrl,
      cost: editCostController.text.trim(),
    );
    await ctrl.db
        .collection("packages")
        .doc(widget.pmodel.packageId!)
        .set(newPackage.toMap());
    const errorSnackBar = SnackBar(content: Text("Data Edited Successfully"));

    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Container(
            padding: const EdgeInsets.all(25),
            child: ListView(
              children: [
                Center(
                  child: CupertinoButton(
                    onPressed: () {
                      showPhotoOptions();
                    },
                    child: availableImage == true
                        ? CircleAvatar(
                            radius: 75,
                            backgroundImage:
                                (widget.pmodel.imageOfPlace!.isNotEmpty)
                                    ? NetworkImage(widget.pmodel.imageOfPlace!)
                                    : NetworkImage(imageUrl),
                            child: (imageFile == null)
                                ? const Icon(Icons.add_a_photo)
                                : null,
                          )
                        : CircleAvatar(
                            radius: 75,
                            backgroundImage: (imageFile != null)
                                ? FileImage(imageFile!)
                                : null,
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
                  controller: editnameController,
                  decoration: const InputDecoration(hintText: "Package Name "),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextField(
                  controller: editCostController,
                  decoration: const InputDecoration(hintText: "Cost"),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextField(
                  maxLines: null,
                  controller: editDescriptionController,
                  decoration: const InputDecoration(hintText: "Description"),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextField(
                  controller: erditDaysController,
                  decoration: const InputDecoration(hintText: "days ..."),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(150, 50),
                        maximumSize: const Size(150, 50),
                      ),
                      onPressed: () {
                        checkValues();
                        uploadData();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          Icon(Icons.edit),
                          Text("Edit"),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(150, 50),
                        maximumSize: const Size(150, 50),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text(" Are You Sure to Delete !"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    await ctrl.db
                                        .collection("packages")
                                        .doc(widget.pmodel.packageId!)
                                        .delete();
                                    setState(() {
                                      editCostController.clear();
                                      editDescriptionController.clear();
                                      editnameController.clear();
                                      erditDaysController.clear();
                                      availableImage = false;
                                    });
                                    // ignore: use_build_context_synchronously
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(" Delete "),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          Icon(Icons.delete),
                          Text("Delete"),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            )),
      ),
    );
  }
}
