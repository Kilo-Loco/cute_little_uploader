import 'dart:io';

import 'package:amplify_flutter/amplify.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class GalleryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _GalleryPageState();
  }
}

class _GalleryPageState extends State<GalleryPage> {
  final picker = ImagePicker();
  List<String> photoPaths = [];

  @override
  void initState() {
    super.initState();
    getPhotos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gallery'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => takePicture(),
      ),
      body: RefreshIndicator(
        onRefresh: () async => getPhotos(),
        child: GridView.builder(
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemCount: photoPaths.length,
          itemBuilder: (context, index) {
            return CachedNetworkImage(
              imageUrl: photoPaths[index],
              fit: BoxFit.cover,
            );
          },
        ),
      ),
    );
  }

  void takePicture() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    if (pickedFile == null) return;

    final key = '${DateTime.now()}.jpg';

    try {
      await Amplify.Storage.uploadFile(
        local: File(pickedFile.path),
        key: key,
      );

      print('uploaded');

      getPhotos();
    } catch (e) {
      print(e);
    }
  }

  void getPhotos() async {
    try {
      final result = await Amplify.Storage.list();

      List<String> photoPaths = await Future.wait(result.items.map(
        (item) async {
          return (await Amplify.Storage.getUrl(key: item.key)).url;
        },
      ));

      setState(() {
        this.photoPaths = photoPaths;
      });
      print(photoPaths);
    } catch (e) {
      print(e);
    }
  }
}
