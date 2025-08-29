import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class AppBackground extends StatefulWidget {
  const AppBackground({super.key});

  
  @override
  State<AppBackground> createState() => AppBackgroundState();
}

class AppBackgroundState extends State<AppBackground> {
  File? _backgroundImage;
  String? _backgroundImagePath;

  final String _imagePath = 'background image';

  @override
  void initState() {
    super.initState();
    _loadImagePath();
  }

  Future<void> _loadImagePath() async {
    final userPrefs = await SharedPreferences.getInstance();
    final savedPath = userPrefs.getString(_imagePath);
    if (savedPath != null && savedPath.isNotEmpty) {
      if (await File(savedPath).exists()) {
        _backgroundImagePath = savedPath;
        setState(() {
          _backgroundImage = File(savedPath);
        });
      } else {
        await userPrefs.remove(_imagePath);
      }
    }
  }

  Future<void> _saveImagePath(String path) async {
    final userPrefs = await SharedPreferences.getInstance();
    await userPrefs.setString(_imagePath, path);
  }

  Future<void> pickImageFile() async {
    try {
      final imageResult = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (imageResult != null) {
        final selectedPlatformFile = imageResult.files.first;
        final newPath = selectedPlatformFile.path;

        if (newPath != null) {
          _backgroundImagePath = newPath;
          setState(() {
            _backgroundImage = File(newPath);
          });
          await _saveImagePath(newPath);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('File picking error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget backgroundWidget;

    if (_backgroundImage != null) {
      backgroundWidget = Image.file(
        File(_backgroundImagePath!),
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
      );
    } else {
      backgroundWidget = Image.asset(
        './assets/test-background-img.jpg',
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
      );
    }

    return Container(
      child: backgroundWidget
    );
  }
}