import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  void initState(){
    super.initState();
  }

  File? imageFile;
  String? _folderPath;


  //  Create and Check the local Directory naemd "newDir"
  void _createLocalFolder() async{
    final directory = await getApplicationDocumentsDirectory();
    final path = Directory('${directory.path}/newDir');

    if(!await path.exists()){
        await path.create();
    }

    setState(() {
      _folderPath = path.path;
    });

  }

  // Choose the photos from the gallery and stor in the local Dir
  void choosePic() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if(pickedFile != null) {
      final file = File(pickedFile.path);
      final newImagePath = await file.copy('${_folderPath}/v-${DateTime.now().microsecond}.jpeg');
      setState(() {
        imageFile = newImagePath;
      });
    }
    _loadImages();
  }


  // Get all images from the Dir and show in the List View

  List<File> _folderImages = [];

  void _loadImages() async {
    if(_folderPath == null) return;
    final dir = await Directory(_folderPath!);
    final allFiles = dir.listSync().where((file) => file.path.endsWith('.jpeg'))
    .map((item) => File(item.path)).toList();
    setState(() {
      _folderImages = allFiles;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Title"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Folder Path: ${_folderPath}"),SizedBox(height: 20,),
              ElevatedButton(onPressed: _createLocalFolder, child: Text("Create Local Directory")),
              imageFile != null ? Image.file(imageFile!) : Text("No image in the Local Dir"),
              SizedBox(height: 20,),
              ElevatedButton(onPressed: choosePic , child: Text("Choose Image")),SizedBox(height: 20,),
              Text("Copied Image Path: ${imageFile?.path.toString()}"),
              // ElevatedButton(onPressed: folderPer , child: Text("Create Ext Folder")),SizedBox(height: 20,),
              // Text("Ext Folder Path: ${_extFolderPath}"),
              Container(
                height: 250, color: Colors.black12,
                child: Expanded(
                    child: ListView.builder(
                        itemCount: _folderImages.length,
                        itemBuilder: (context,index) {
                          return Card(
                            child: ListTile(
                              title: Text(_folderImages[index].path.split('/').last),
                              leading: Image.file(_folderImages[index],height: 50,width: 50,fit: BoxFit.cover,),
                            ),
                          );
                        }
                    )
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}







/*  void createExtFolder() async {
    // final storagePermission = await Permission.storage.request();
    if(await Permission.storage.request().isGranted) {
    final path = await getExternalStorageDirectory();
    final _newFolderPath = await Directory('${path!.path}/extFolder');
    print('-------  ${path}');
    print('=======  ${_newFolderPath}');
    // if(!await _newFolderPath.exists()){
    //   await _newFolderPath.create();
    // }
    // setState(() {
    //   _extFolderPath = _newFolderPath.path;
    // });

    }
  }*/

/* Future<void> createLocalDir() async {
    // 1. Request permission
    if (await Permission.storage.request().isGranted) {
      // 2. Get external storage directory
      Directory? externalDir = await getExternalStorageDirectory();

      // 3. Create the folder path
      final String newPath = "${externalDir!.path}/VaibhavFolder";
      final Directory folder = Directory(newPath);

      // 4. Check and create the folder
      if (!await folder.exists()) {
        await folder.create(recursive: true);
      }

      // 5. Update the UI with the new path
      setState(() {
        _extFolderPath = folder.path;
      });

      print("Folder created at: $newPath");
    } else {
      print("Storage permission denied.");
    }
  }*/

// void folderPer() async {
//   final per = await Permission.storage.request();
//   if(per.isGranted){
//     print("STORAGE PERMISSION GRANTED");
//   } else {
//     print("STORAGE PERMISSION DENIED");
//   }
// }

/* void folderPer() async {
    // Check Android version
    if (await Permission.storage.isGranted) {
      print("STORAGE PERMISSION ALREADY GRANTED");
      return;
    }

    // Request appropriate permissions based on Android version
    Map<Permission, PermissionStatus> statuses;

    if (await Permission.storage.isDenied) {
      statuses = await [
        Permission.storage,
        Permission.manageExternalStorage, // For Android 11+
      ].request();

      if (statuses[Permission.storage]!.isGranted ||
          statuses[Permission.manageExternalStorage]!.isGranted) {
        print("STORAGE PERMISSION GRANTED");
      } else if (statuses[Permission.storage]!.isPermanentlyDenied) {
        print("PERMISSION PERMANENTLY DENIED. Redirecting to settings...");
        await openAppSettings();
      } else {
        print("STORAGE PERMISSION DENIED");
      }
    }
  }*/