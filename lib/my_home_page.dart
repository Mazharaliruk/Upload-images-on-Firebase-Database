
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:upload_images_into_firebase/Api/fire_base_api.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  UploadTask? task;
  File? file;

  Widget buildMyButton({required String text, required IconData icon, required dynamic onPress}){
    return Container(
      height: 60,
      width: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.green
      ),
      child: MaterialButton(
        onPressed: onPress,
        child: Row(
          children: [
            Icon(icon,color: Colors.white,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 70),
              child: Text(
                text,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18
                ),
              ),
            )
          ],
        ),
      ),
    );
  }


  Future selectFile() async{
    final result = await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    if(result == null) return;
    final path = result.path;
    setState(() {
       file = File(path);
    });
  }

  Future uploadFiles() async{
    if(file == null) return;
    final filename = basename(file!.path);
    final destination = "image/$filename";

    FirebaseApi.uploadFiles(destination: destination, file: file!);
  }

  @override
  Widget build(BuildContext context) {
    final filename =  file !=null? basename(file!.path):'No File Selected';

    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload Images into firebase"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            buildMyButton(
              onPress: () => selectFile(),
              icon: Icons.attach_file_outlined,
                text: "Pick Files"
            ),
            Text(
              filename
            ),
            SizedBox(height: 20,),
            buildMyButton(
              onPress: () => uploadFiles(),
              icon: Icons.upload,
                text: "Upload Files"
            )
          ],
        ),
      ),
    );
  }
}
