import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photofilters/photofilters.dart';
import 'package:image/image.dart' as image_lib;

class CameraFilter extends StatefulWidget {
  const CameraFilter({super.key});

  @override
  State<CameraFilter> createState() => _CameraFilterState();
}

class _CameraFilterState extends State<CameraFilter> {
  late String fileName;
  List<Filter> filters = presetFiltersList;
  final picker = ImagePicker();
  late File imageFile;

  @override
  void initState() {
    const filePath = "assets/images/logo.png";
    imageFile = File(filePath);
    super.initState();
  }

  Future getImage(context) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      fileName = basename(imageFile.path);
      var image = image_lib.decodeImage(await imageFile.readAsBytes());
      image = image_lib.copyResize(
        image!,
        width: 750,
      );
      Map imagefile = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PhotoFilterSelector(
            title: const Text("Photo Filter Example"),
            image: image!,
            filters: presetFiltersList,
            filename: fileName,
            loader: const Center(child: CircularProgressIndicator()),
            fit: BoxFit.contain,
          ),
        ),
      );

      if (imagefile.containsKey('image_filtered')) {
        setState(() {
          imageFile = imagefile['image_filtered'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 24, 22, 44),
      body: Center(
        child: Image.file(File(imageFile.path)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => getImage(context),
        tooltip: 'Pick Image',
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }
}
