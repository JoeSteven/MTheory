import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:remove/music/circle_of_fifths_util.dart';

class CircleOfFifthPage extends StatefulWidget {
  @override
  _CircleOfFifthPage createState() {
    return new _CircleOfFifthPage();
  }
}

class _CircleOfFifthPage extends State<CircleOfFifthPage> {

  final _inputUp = new TextEditingController();
  final _inputDown = new TextEditingController();
  var _answerText = " ";
  var _answerColor = Colors.black;
  var _questionText = CFUtil.randomNote();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("五度圈练习"),
        ),
        body: new Container(
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _question(),
              _upInput(),
              _downInput(),
              _answer(),
              _buttons(),
            ],
          ),
          margin: new EdgeInsets.all(10),
        ));
  }

  Text _question() {
    return new Text(_questionText, style: new TextStyle(
        fontSize: 30,
        color: Colors.black
    ),);
  }

  Row _upInput() {
    return new Row(
      children: <Widget>[
        new Text("上行五度"),
        new Expanded(child: TextField(
          controller: _inputUp,
//          keyboardType: TextInputType.text,
        ))
      ],
    );
  }

  Row _downInput() {
    return new Row(
      children: <Widget>[
        new Text("下行五度"),
        new Expanded(child: TextField(
          controller: _inputDown,
//          keyboardType: TextInputType.text,
        ))
      ],
    );
  }

  Text _answer() {
    return new Text(_answerText, style: TextStyle(color: _answerColor),);
  }

  Row _buttons() {
    return Row(
      children: <Widget>[
        new Expanded(child: new MaterialButton(
          onPressed: _commitAnswer,
          color: Colors.green,
          textColor: Colors.white,
          padding: EdgeInsets.all(10),
          child: new Text("提交答案"),)),
        new Text(" "),
        new Expanded(child: new MaterialButton(
          onPressed: _nextQuestion,
          color: Colors.blue,
          textColor: Colors.white,
          padding: EdgeInsets.all(10),
          child: new Text("下一题"),)),
      ],
    );
  }

  _commitAnswer() {
    var up = CFUtil.upFifth(_questionText);
    var down = CFUtil.downFifth(_questionText);
    var upAnswer = _inputUp.text;
    var downAnswer = _inputDown.text;
    if (up == upAnswer && down == downAnswer) {
      setState(() {
        _answerColor = Colors.black;
        _answerText = "正确：上行 $up,下行 $down";
      });
    } else {
      setState(() {
        _answerColor = Colors.red;
        _answerText = "错误：上行 $up,下行 $down";
      });
    }
  }

  _nextQuestion() {
    setState(() {
      _answerColor = Colors.black;
      _questionText = CFUtil.randomNote();
      _answerText = " ";
      _inputUp.clear();
      _inputDown.clear();
    });
  }


}