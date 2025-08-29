import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BlurScreen extends StatefulWidget {
  const BlurScreen({super.key});

  @override
  State<BlurScreen> createState() => BlurScreenState();
}

class BlurScreenState extends State<BlurScreen> {
  double _blurValue = 0.0;

  final String _key = 'blur value';

  @override
  void initState() {
    super.initState();
    _loadBlurValue();
  }

  Future<void> _loadBlurValue() async {
    final loadedBlurValue = await SharedPreferences.getInstance();

    final savedBlur = loadedBlurValue.getDouble(_key) ?? 0.0;

    setState(() {
      _blurValue = savedBlur;
    });
  }

  Future<void> _saveBlurValue() async {
    final blurValue = await SharedPreferences.getInstance();

    await blurValue.setDouble(_key, _blurValue);
  }

  Future<void> blurDialog() async {
    TextEditingController controller = TextEditingController();

    final blurValue = await showDialog<String>(
      context: context,
      builder: (BuildContext content) {
        return AlertDialog(
          title: Text('Enter Blur Value'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: '0 - however much you want'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(controller.text),
              child: Text('Set')
            )
          ],
        );
      }
    );

    if (blurValue != null && blurValue.isNotEmpty) {
      final newBlurValue = double.tryParse(blurValue);
      if (newBlurValue != null) {
        setState(() {
          _blurValue = newBlurValue;
        });
        _saveBlurValue();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: _blurValue, sigmaY: _blurValue),
        child: Container(color: Colors.black.withOpacity(0.0)),
      )
    );
  }
}