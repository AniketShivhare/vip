import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

late String s="";

class _MyAppState extends State<MyApp> {
  final ImagePicker picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white60,
            body: Column(
              children: [
                Container(
                  height: 250,
                  width: 250,
                  child: Center(
                    child: GestureDetector(
                        onTap: () async {
                          final XFile? image =
                          await picker.pickImage(source: ImageSource.gallery);
                          String a = await getImageTotext(image!.path);
                          setState(() {
                            s = a;
                          });
                        },
                        child: const Icon(
                          Icons.file_copy,
                        )),
                  ),
                ),
                Text(
                  s,
                  style: TextStyle(color: Colors.black, fontSize: 20),
                )
              ],
            ),
          )),
    );
  }
}

Future getImageTotext(final imagePath) async {
  final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  final RecognizedText recognizedText =
  await textRecognizer.processImage(InputImage.fromFilePath(imagePath));
  String text = recognizedText.text.toString();
  return text;
}
