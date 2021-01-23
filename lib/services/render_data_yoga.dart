import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class RenderDataYoga extends StatefulWidget {
  final List<dynamic> data;
  final int previewH;
  final int previewW;
  final double screenH;
  final double screenW;
  final Map<String, dynamic> posedata;

  RenderDataYoga(
      {this.data,
      this.previewH,
      this.previewW,
      this.screenH,
      this.screenW,
      this.posedata});
  @override
  _RenderDataYogaState createState() => _RenderDataYogaState();
}

class _RenderDataYogaState extends State<RenderDataYoga> {
  Map<String, List<double>> inputArr;
  static const double err = 15;

  String excercise = '';
  double upperRange = 300;
  double lowerRange = 500;
  bool midCount, isCorrectPosture;
  // int countdown;
  Color correctColor;
  bool pos1, pos2, pos3;
  double shoulderLY;
  double shoulderRY;
  Timer _timer;
  dynamic lang;
  dynamic rang;
  int countdown;

  double wristLX, wristLY, wristRX, wristRY, elbowLX, elbowRX;
  double rAnkleX, rAnkleY, lAnkleX, lAnkleY;
  double kneeRY;
  double kneeLY;
  bool squatUp;
  String angle;
  String whatToDo = 'Finding Posture';

  var leftEyePos = Vector(0, 0);
  var rightEyePos = Vector(0, 0);
  var leftShoulderPos = Vector(0, 0);
  var rightShoulderPos = Vector(0, 0);
  var leftHipPos = Vector(0, 0);
  var rightHipPos = Vector(0, 0);
  var leftElbowPos = Vector(0, 0);
  var rightElbowPos = Vector(0, 0);
  var leftWristPos = Vector(0, 0);
  var rightWristPos = Vector(0, 0);
  var leftKneePos = Vector(0, 0);
  var rightKneePos = Vector(0, 0);
  var leftAnklePos = Vector(0, 0);
  var rightAnklePos = Vector(0, 0);

  @override
  void initState() {
    inputArr = new Map();
    midCount = false;
    isCorrectPosture = false;
    // _counter = 0;

    correctColor = Colors.red;
    shoulderLY = 0;
    pos1 = false;
    pos2 = false;
    pos3 = false;
    shoulderRY = 0;
    countdown = 30;
    angle = '';
    kneeRY = 0;
    kneeLY = 0;
    squatUp = true;
    super.initState();
    excercise = widget.posedata['poseName'];
  }

  double _calradian(List a1, List a2) {
    double c = math.atan2((a2[1] - a1[1]), (a2[0] - a1[0]));
    return c * (180 / math.pi);
    // double newang = ang * (math.pi / 180);
    // double upperrange = newang + err;
    // double lowerrange = newang - err;
  }

  void _stopTimer() {
    if (_timer != null) {
      _timer.cancel();
    }
  }

  void _startTimer() {
    // _counter = 10;
    if (_timer != null) {
      _timer.cancel();
    }
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (countdown > 0) {
          countdown--;
        } else {
          _timer.cancel();
        }
      });
    });
  }

  bool _calculateAngle(List a1, List a2, double ang) {
    double rad = math.atan2((a2[1] - a1[1]), (a2[0] - a1[0]));
    double newang = rad * (180 / math.pi);
    double upperrange = ang + err;
    double lowerrange = ang - err;
    if (newang < upperrange && newang > lowerrange) {
      return true;
    } else {
      return false;
    }
  }

  bool _postureAccordingToExercise(Map<String, List<double>> poses) {
    whatToDo = 'Finding Posture';
    pos1 = false;
    pos2 = false;
    pos3 = false;
    Map<String, dynamic> pd = widget.posedata;
    // setState(() {
    //   whatToDo = _calradian(
    //           poses[pd['pose1Condition'][3]], poses[pd['pose1Condition'][4]])
    //       .toStringAsFixed(2);

    //   excercise = _calradian(
    //           poses[pd['pose2Condition'][0]], poses[pd['pose2Condition'][1]])
    //       .toStringAsFixed(2);

    //   angle = _calradian(
    //           poses[pd['pose3Condition'][0]], poses[pd['pose3Condition'][1]])
    //       .toStringAsFixed(2);
    // });

    if (pd['pose1Condition'].length > 3) {
      if (_calculateAngle(
              poses[pd['pose1Condition'][0]],
              poses[pd['pose1Condition'][1]],
              double.parse(pd['pose1Condition'][2])) &&
          _calculateAngle(
              poses[pd['pose1Condition'][3]],
              poses[pd['pose1Condition'][4]],
              double.parse(pd['pose1Condition'][5]))) {
        // whatToDo = "Hands Are Aligned";
        pos1 = true;
      }
    } else {
      if (_calculateAngle(
          poses[pd['pose1Condition'][0]],
          poses[pd['pose1Condition'][1]],
          double.parse(pd['pose1Condition'][2]))) {
        // whatToDo = "Hands Are Aligned";
        pos1 = true;
      }
    }

    if (pd['pose2Condition'].length > 3) {
      if (_calculateAngle(
              poses[pd['pose2Condition'][0]],
              poses[pd['pose2Condition'][1]],
              double.parse(pd['pose2Condition'][2])) &&
          _calculateAngle(
              poses[pd['pose2Condition'][3]],
              poses[pd['pose2Condition'][4]],
              double.parse(pd['pose2Condition'][5]))) {
        // whatToDo = "Hands Are Aligned";
        pos2 = true;
      }
    } else {
      if (_calculateAngle(
          poses[pd['pose2Condition'][0]],
          poses[pd['pose2Condition'][1]],
          double.parse(pd['pose2Condition'][2]))) {
        // whatToDo = "Hands Are Aligned";
        pos2 = true;
      }
    }

    if (pd['pose3Condition'].length > 3) {
      if (_calculateAngle(
              poses[pd['pose3Condition'][0]],
              poses[pd['pose3Condition'][1]],
              double.parse(pd['pose3Condition'][2])) &&
          _calculateAngle(
              poses[pd['pose3Condition'][3]],
              poses[pd['pose3Condition'][4]],
              double.parse(pd['pose3Condition'][5]))) {
        // whatToDo = "Hands Are Aligned";
        pos3 = true;
      }
    } else {
      if (_calculateAngle(
          poses[pd['pose3Condition'][0]],
          poses[pd['pose3Condition'][1]],
          double.parse(pd['pose3Condition'][2]))) {
        // whatToDo = "Hands Are Aligned";
        pos3 = true;
      }
    }

    //45 Degree Ankle

    // if (_calculateAngle(poses['leftShoulder'], poses['leftElbow'], 0) &&
    //     _calculateAngle(poses['rightElbow'], poses['rightShoulder'], 0)) {
    //   // whatToDo = "Hands Are Aligned";
    //   pos1 = true;
    // }
    // //Hands Aligned
    // if (_calculateAngle(poses['rightHip'], poses['rightKnee'], 120)) {
    //   // whatToDo = "Right Leg Angle Correct";
    //   pos2 = true;
    // }
    // //45 Degree Ankle
    // if (_calculateAngle(poses['leftHip'], poses['leftKnee'], 40)) {
    //   // return true;
    //   pos3 = true;
    // }

    // return False;

    // return False;

    setState(() {
      // whatToDo;
      pos1;
      pos2;
      pos3;
    });
    return pos1 && pos2 && pos3;
  }

  _checkCorrectPosture(Map<String, List<double>> poses) {
    if (_postureAccordingToExercise(poses)) {
      if (!isCorrectPosture) {
        setState(() {
          isCorrectPosture = true;
          correctColor = Colors.green;
          whatToDo = 'Great!!Now Hold Onto This';
        });
        _startTimer();
        if (countdown == 0) {
          setState(() {
            whatToDo = 'Done';
          });
          _stopTimer();
        }
      }
    } else {
      if (isCorrectPosture) {
        setState(() {
          isCorrectPosture = false;
          correctColor = Colors.red;
          whatToDo = 'Finding Posture';
        });
        _stopTimer();
      }
    }
  }

  Future<void> _countingLogic(Map<String, List<double>> poses) async {
    if (poses != null) {
      _checkCorrectPosture(poses);

      if (isCorrectPosture && squatUp && midCount == false) {
        //in correct initial posture
        // setState(() {
        //   whatToDo = 'Squat Down';
        //   //correctColor = Colors.green;
        // });
        // squatUp = !squatUp;
        // isCorrectPosture = false;
      }

      //lowered all the way
      if (isCorrectPosture && !squatUp && midCount == false) {
        // midCount = true;
        // isCorrectPosture = false;
        // squatUp = !squatUp;
        // setState(() {
        //   whatToDo = 'Go Up';
        //   //correctColor = Colors.green;
        // });
      }

      //back up
      if (midCount &&
          poses['leftShoulder'][1] < 320 &&
          poses['leftShoulder'][1] > 280 &&
          poses['rightShoulder'][1] < 320 &&
          poses['rightShoulder'][1] > 280) {
        // incrementCounter();
        // midCount = false;
        // squatUp = !squatUp;
        setState(() {
          //whatToDo = 'Go Up';
        });
      }
    }
  }

  // void incrementCounter() {
  //   setState(() {
  //     _counter++;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    void _getKeyPoints(k, x, y) {
      if (k["part"] == 'leftEye') {
        leftEyePos.x = x - 230;
        leftEyePos.y = y - 45;
      }
      if (k["part"] == 'rightEye') {
        rightEyePos.x = x - 230;
        rightEyePos.y = y - 45;
      }
      if (k["part"] == 'leftShoulder') {
        leftShoulderPos.x = x - 230;
        leftShoulderPos.y = y - 45;
      }
      if (k["part"] == 'rightShoulder') {
        rightShoulderPos.x = x - 230;
        rightShoulderPos.y = y - 45;
      }
      if (k["part"] == 'leftElbow') {
        leftElbowPos.x = x - 230;
        leftElbowPos.y = y - 45;
      }
      if (k["part"] == 'rightElbow') {
        rightElbowPos.x = x - 230;
        rightElbowPos.y = y - 45;
      }
      if (k["part"] == 'leftWrist') {
        leftWristPos.x = x - 230;
        leftWristPos.y = y - 45;
      }
      if (k["part"] == 'rightWrist') {
        rightWristPos.x = x - 230;
        rightWristPos.y = y - 45;
      }
      if (k["part"] == 'leftHip') {
        leftHipPos.x = x - 230;
        leftHipPos.y = y - 45;
      }
      if (k["part"] == 'rightHip') {
        rightHipPos.x = x - 230;
        rightHipPos.y = y - 45;
      }
      if (k["part"] == 'leftKnee') {
        leftKneePos.x = x - 230;
        leftKneePos.y = y - 45;
      }
      if (k["part"] == 'rightKnee') {
        rightKneePos.x = x - 230;
        rightKneePos.y = y - 45;
      }
      if (k["part"] == 'leftAnkle') {
        leftAnklePos.x = x - 230;
        leftAnklePos.y = y - 45;
      }
      if (k["part"] == 'rightAnkle') {
        rightAnklePos.x = x - 230;
        rightAnklePos.y = y - 45;
      }
    }

    List<Widget> _renderKeypoints() {
      var lists = <Widget>[];
      widget.data.forEach((re) {
        var list = re["keypoints"].values.map<Widget>((k) {
          var _x = k["x"];
          var _y = k["y"];
          var scaleW, scaleH, x, y;

          if (widget.screenH / widget.screenW >
              widget.previewH / widget.previewW) {
            scaleW = widget.screenH / widget.previewH * widget.previewW;
            scaleH = widget.screenH;
            var difW = (scaleW - widget.screenW) / scaleW;
            x = (_x - difW / 2) * scaleW;
            y = _y * scaleH;
          } else {
            scaleH = widget.screenW / widget.previewW * widget.previewH;
            scaleW = widget.screenW;
            var difH = (scaleH - widget.screenH) / scaleH;
            x = _x * scaleW;
            y = (_y - difH / 2) * scaleH;
          }
          inputArr[k['part']] = [x, y];
          //Mirroring
          if (x > 320) {
            var temp = x - 320;
            x = 320 - temp;
          } else {
            var temp = 320 - x;
            x = 320 + temp;
          }

          _getKeyPoints(k, x, y);

          if (k["part"] == 'leftEye') {
            leftEyePos.x = x - 230;
            leftEyePos.y = y - 45;
          }
          if (k["part"] == 'rightEye') {
            rightEyePos.x = x - 230;
            rightEyePos.y = y - 45;
          }
          return Positioned(
            left: x - 290,
            top: y - 50,
            width: 200,
            height: 15,
            child: Container(
              child: Text(
                "● ${k["part"]}",
                style: TextStyle(
                  color: Color.fromRGBO(37, 213, 253, 1.0),
                  fontSize: 12.0,
                ),
              ),
            ),
          );
        }).toList();
        setState(() {
          // rang = _calradian(inputArr['rightHip'], inputArr['rightKnee']);
          // lang = _calradian(inputArr['leftElbow'], inputArr['leftShoulder']);
          // rang = inputArr['rightShoulder'];
          // lang = inputArr['rightElbow'];
        });

        // print("left angle is ${lang.toStringAsFixed(2)}");
        // print("right angle is ${rang.toStringAsFixed(2)}")

        _countingLogic(inputArr);
        inputArr.clear();

        lists..addAll(list);
      });
      //lists.clear();

      return lists;
    }

    return Stack(
      children: <Widget>[
        correctColor == Colors.red
            ? Stack(
                children: [
                  CustomPaint(
                    painter: MyPainter(
                        left: leftShoulderPos, right: rightShoulderPos),
                  ),
                  CustomPaint(
                    painter:
                        MyPainter(left: leftElbowPos, right: leftShoulderPos),
                  ),
                  CustomPaint(
                    painter: MyPainter(left: leftWristPos, right: leftElbowPos),
                  ),
                  CustomPaint(
                    painter:
                        MyPainter(left: rightElbowPos, right: rightShoulderPos),
                  ),
                  CustomPaint(
                    painter:
                        MyPainter(left: rightWristPos, right: rightElbowPos),
                  ),
                  CustomPaint(
                    painter:
                        MyPainter(left: leftShoulderPos, right: leftHipPos),
                  ),
                  CustomPaint(
                    painter: MyPainter(left: leftHipPos, right: leftKneePos),
                  ),
                  CustomPaint(
                    painter: MyPainter(left: leftKneePos, right: leftAnklePos),
                  ),
                  CustomPaint(
                    painter:
                        MyPainter(left: rightShoulderPos, right: rightHipPos),
                  ),
                  CustomPaint(
                    painter: MyPainter(left: rightHipPos, right: rightKneePos),
                  ),
                  CustomPaint(
                    painter:
                        MyPainter(left: rightKneePos, right: rightAnklePos),
                  ),
                  CustomPaint(
                    painter: MyPainter(left: leftHipPos, right: rightHipPos),
                  ),
                ],
              )
            : null,
        Stack(children: _renderKeypoints()),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 150,
            width: widget.screenW,
            decoration: BoxDecoration(
              color: correctColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25)),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    '$whatToDo\n $excercise \n Counter: ${countdown.toString()}s',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.posedata['pose1'],
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: pos1 ? Colors.amber : Colors.black),
                  ),
                  Text(
                    widget.posedata['pose2'],
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: pos2 ? Colors.amber : Colors.black),
                  ),
                  Text(
                    widget.posedata['pose3'],
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: pos3 ? Colors.amber : Colors.black),
                  )
                  // Text(
                  //   'first angle' + whatToDo,
                  //   style: TextStyle(
                  //       fontSize: 20,
                  //       fontWeight: FontWeight.bold,
                  //       color: pos1 ? Colors.amber : Colors.black),
                  // ),

                  // Text(
                  //   'second angle' + excercise,
                  //   style: TextStyle(
                  //       fontSize: 20,
                  //       fontWeight: FontWeight.bold,
                  //       color: pos1 ? Colors.amber : Colors.black),
                  // ),
                  // Text(
                  //   'third angle' + angle,
                  //   style: TextStyle(
                  //       fontSize: 20,
                  //       fontWeight: FontWeight.bold,
                  //       color: pos1 ? Colors.amber : Colors.black),
                  // )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class Vector {
  double x, y;
  Vector(this.x, this.y);
}

class MyPainter extends CustomPainter {
  Vector left;
  Vector right;
  MyPainter({this.left, this.right});
  @override
  void paint(Canvas canvas, Size size) {
    final p1 = Offset(left.x, left.y);
    final p2 = Offset(right.x, right.y);
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 4;
    canvas.drawLine(p1, p2, paint);
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}
