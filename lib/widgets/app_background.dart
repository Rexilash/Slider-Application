import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class AppBackground extends StatefulWidget {
  const AppBackground({super.key});

  
  @override
  State<AppBackground> createState() => AppBackgroundState();
}

class AppBackgroundState extends State<AppBackground> {
  File? _backgroundImage;

  Future<void> pickImageFile() async {
    FilePickerResult? imageResult;

    try {
      imageResult = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (imageResult != null) {
        PlatformFile selectedPlatformFile = imageResult.files.first;

        if (selectedPlatformFile.path != null) {
          File imageSetAsBackground = File(selectedPlatformFile.path!);

          setState(() {
            _backgroundImage = imageSetAsBackground;
          });
        } else {

        }
      } else {

      }
    } catch (e) {
      if (kDebugMode) {
        print('File picking error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget BackgroundWidget;

    if (_backgroundImage != null) {
      BackgroundWidget = Image.file(
        _backgroundImage!,
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
      );
    } else {
      BackgroundWidget = Image.asset(
        './assets/test-background-img.jpg',
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
      );
    }

    return Container(
      child: BackgroundWidget
    );
  }
}