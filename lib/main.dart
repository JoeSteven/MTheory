import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:remove/i18n/locale_util.dart';
import 'package:remove/i18n/translations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    localeUtil.context = context;
    return MaterialApp(
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
        primarySwatch: Colors.green,
      ),
      localizationsDelegates: [
        const TranslationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: localeUtil.supportedLocales(),
      home: new MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPage createState() {
    return new _MainPage();
  }
}

class _MainPage extends State<MainPage> {
  var isSelected = false;
  var showLoading = false;
  var _img;
  final httpClient = new Dio();

  Future _upload() async {
    if (showLoading) return;
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    print(image);
    setState(() {
      if (_img != image) {
        print("change image");
        _img = image;
        isSelected = true;
        showLoading = true;
      }
    });
    // 网络请求
    print("upload file$_img");
    FormData formData = new FormData.from(
        {"size": "auto", "image_file": new UploadFileInfo(_img, "image_file")});
    try {
      var response = await httpClient.post(
          "https://api.remove.bg/v1.0/removebg",
          data: formData,
          options:
              new Options(headers: {"X-Api-Key": "5kVUg5TM31JoTvXmX9oeQqxE"}, responseType: ResponseType.stream));
      print(response.data);
      ResponseBody resp = response.data;

      Uint8List imageBytes = await consolidateHttpClientResponseBytes(resp.stream);
      print(imageBytes.length);
      if (imageBytes != null) {
        setState(() {
          _img = imageBytes;
        });
      }
    } catch (e) {
      if (e is DioError) {
        print(e?.response?.data);
      }
    }

    setState(() {
      showLoading = false;
    });
  }

  Future<Uint8List> consolidateHttpClientResponseBytes(Stream<List<int>> response
      ) {
    // response.contentLength is not trustworthy when GZIP is involved
    // or other cases where an intermediate transformer has been applied
    // to the stream.
    final Completer<Uint8List> completer = Completer<Uint8List>.sync();
    final List<List<int>> chunks = <List<int>>[];
    int contentLength = 0;
    response.listen((List<int> chunk) {
      chunks.add(chunk);
      contentLength += chunk.length;
    }, onDone: () {
      final Uint8List bytes = Uint8List(contentLength);
      int offset = 0;
      for (List<int> chunk in chunks) {
        bytes.setRange(offset, offset + chunk.length, chunk);
        offset += chunk.length;
      }
      completer.complete(bytes);
    }, onError: completer.completeError, cancelOnError: true);

    return completer.future;
  }

  void _download() {
    if (showLoading) return;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(localeUtil.getString("title")),
        ),
        body: new Container(
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Expanded(child: _image(_img)),
              _loadView(),
              _stateView()
            ],
          ),
          margin: new EdgeInsets.all(10),
        ));
  }

  Image _image(Object image) {
    if (image is File) {
      return Image.file(image);
    } else if (image is Uint8List) {
      return Image.memory(image);
    } else {
      return new Image(image: AssetImage("imgs/upload.png"));
    }
  }

  CircularProgressIndicator _loadView() {
    if (showLoading) {
      return new CircularProgressIndicator();
    } else {
      return new CircularProgressIndicator(
          strokeWidth: 0,
          valueColor: AlwaysStoppedAnimation(Colors.transparent));
    }
  }

  Row _stateView() {
    if (isSelected) {
      return new Row(children: <Widget>[
        new Expanded(
            child: new MaterialButton(
          onPressed: _upload,
          color: Colors.blue,
          textColor: Colors.white,
          padding: EdgeInsets.all(10),
          child: new Text(localeUtil.getString("change_photo")),
        )),
        new Text(" "),
        new Expanded(
            child: new MaterialButton(
                onPressed: _download,
                color: Colors.green,
                textColor: Colors.white,
                padding: EdgeInsets.all(10),
                child: new Text(localeUtil.getString("download_photo"))))
      ]);
    }
    return new Row(children: <Widget>[
      new Expanded(
          child: new MaterialButton(
        onPressed: _upload,
        color: Colors.green,
        textColor: Colors.white,
        padding: EdgeInsets.all(10),
        child: new Text(localeUtil.getString("upload_photo")),
      ))
    ]);
  }
}
