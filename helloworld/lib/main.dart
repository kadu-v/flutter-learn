import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'test_page1.dart';
import 'test_page2.dart';
import 'test_page3.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      routes: {
        "/test1": (BuildContext context) => TestPage1(),
        "/test2": (BuildContext context) => TestPage2(),
        "/test3": (BuildContext context) => TestPage3(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  VideoPlayerController? _controller;
  final imagePicker = ImagePicker();

  // カメラから動画を取得するメソッド
  Future getVideoFromCamera() async {
    XFile? pickedFile = await imagePicker.pickVideo(source: ImageSource.camera);
    if (pickedFile != null) {
      _controller = VideoPlayerController.file(File(pickedFile.path));
      _controller!.initialize().then((_) {
        setState(() {
          _controller!.play();
        });
      });
    }
  }

  // ギャラリーから動画を取得するメソッド
  Future getVideoFromGarally() async {
    XFile? pickedFile =
        await imagePicker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      _controller = VideoPlayerController.file(File(pickedFile.path));
      _controller!.initialize().then((_) {
        setState(() {
          _controller!.play();
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
            // 取得した動画を表示(ない場合はメッセージ)
            child: _controller == null
                ? Text(
                    '動画を選択してください',
                    style: Theme.of(context).textTheme.headline4,
                  )
                : VideoPlayer(_controller!)),
        floatingActionButton:
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          // カメラから取得するボタン
          FloatingActionButton(
              onPressed: getVideoFromCamera,
              child: const Icon(Icons.video_call)),
          // ギャラリーから取得するボタン
          FloatingActionButton(
              onPressed: getVideoFromGarally,
              child: const Icon(Icons.movie_creation))
        ]));
  }
}
