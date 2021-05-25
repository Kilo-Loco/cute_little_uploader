import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:cute_little_uploader/amplifyconfiguration.dart';
import 'package:cute_little_uploader/gallery_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  bool _isAmplifyConfigured = false;

  @override
  void initState() {
    super.initState();
    configureAmplify();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: _isAmplifyConfigured
          ? GalleryPage()
          : Center(child: CircularProgressIndicator()),
    );
  }

  void configureAmplify() async {
    Amplify.addPlugins([AmplifyAuthCognito(), AmplifyStorageS3()]);

    try {
      await Amplify.configure(amplifyconfig);
      print('amplify configured');
      setState(() {
        _isAmplifyConfigured = true;
      });
    } catch (e) {
      print(e);
    }
  }
}
