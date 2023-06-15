import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyGalleryApp(),
    );
  }
}

class MyGalleryApp extends StatefulWidget {
  const MyGalleryApp({Key? key}) : super(key: key);

  @override
  State<MyGalleryApp> createState() => _MyGalleryAppState();
}

class _MyGalleryAppState extends State<MyGalleryApp> {
  /// ImagePicker에서 사진을 여러 장 가져올 수 있다.
  final ImagePicker _picker = ImagePicker();

  /// 여러장의 사진은 Xfile형태이고 List로 받는데 처음에는 없기때문에 ?(Null) 허용한다.
  List<XFile>? images;

  /// 처음 사진을 선택할 수 있게 한다.
  @override
  void initState() {
    super.initState();

    loadImages();
  }

  /// 사진을 가져오는데 시간이 오래 걸린다. 그래서 Future로
  Future<void> loadImages() async {
    images = await _picker.pickMultiImage();

    /// Future를 사용하는 images를 setState안에 넣으며 안된다.
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('전자액자'),
      ),

      /// 사진을 가져와서 메모리에 담았다가 사용한다.
      body: images == null
          ? const Center(child: Text('No data'))
          : FutureBuilder<Uint8List>(
              future: images![0].readAsBytes(),
              builder: (context, snapshot) {
                /// UI를 구성하는 부분, 사진ㅇ은 snapshot을 통해 들어온다.
                final data = snapshot.data;

                if (data == null ||
                    snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                return Image.memory(
                  data,
                  width: double.infinity,
                );
              }),
    );
  }
}
