import 'package:align_ai/main.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:align_ai/widgets/search_bar.dart';

import 'pushed_pageA.dart';
import 'pushed_pageS.dart';
import 'pushed_pageY.dart';

class MainScreen extends StatelessWidget {
  final List<CameraDescription> cameras;
  MainScreen(this.cameras);

  static const String id = 'main_screen';
  @override
  Widget build(BuildContext context) {
    List<dynamic> poses = [
      {
        'poseName': 'Warroir Pose 2',
        'pose1': 'Align Your Hands Horizontally',
        'pose2': 'Straighten Your Right Leg at 30Degree',
        'pose3': 'Bend Your Left Leg',
        'pose1Condition': [
          'leftShoulder',
          'leftElbow',
          '0',
          'rightElbow',
          'rightShoulder',
          '0'
        ],
        'pose2Condition': ['rightKnee', 'rightHip', '-60'],
        'pose3Condition': ['leftHip', 'leftKnee', '60']
      },
      {
        'poseName': 'Warroir Pose 1',
        'pose1': 'Align Your Hands Vertically',
        'pose2': 'Straighten Your Right Leg at 30Degree',
        'pose3': 'Bend Your Left Leg',
        'pose1Condition': [
          'leftShoulder',
          'leftElbow',
          '-80',
          'rightElbow',
          'rightShoulder',
          '80'
        ],
        'pose2Condition': ['rightKnee', 'rightHip', '-60'],
        'pose3Condition': ['leftHip', 'leftKnee', '60']
      },
      {
        'poseName': 'Triangle Pose',
        'pose1': 'Join Your Hands Vertically ',
        'pose2': 'Balance Right Foot on Left Knee',
        'pose3': 'Keep Your Left Leg Straight',
        'pose1Condition': [
          'leftShoulder',
          'leftElbow',
          '-80',
          'rightElbow',
          'rightShoulder',
          '80'
        ],
        'pose2Condition': ['rightKnee', 'rightAnkle', '45'],
        'pose3Condition': ['leftHip', 'leftKnee', '80']
      }
    ];

    List<Widget> posewidget = poses
        .map((p) => (Stack(
              children: <Widget>[
                Container(
                  width: 140,
                  height: 140,
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0)),
                    color: Colors.white,
                    child: Container(
                        padding: EdgeInsets.all(10.0),
                        child: Image.asset('images/yoga4.PNG')),
                    onPressed: () => onSelectY(
                        context: context, modelName: 'posenet', poseData: p),
                  ),
                ),
                Text(p['poseName']),
              ],
            )))
        .toList();
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        // appBar: AppBar(
        //   title: Text('Align.AI'),
        //   backgroundColor: Colors.blueAccent,
        // ),
        body: ListView(
          children: <Widget>[
            ...posewidget,
            // Stack(
            //   children: <Widget>[
            //     Container(
            //       width: 140,
            //       height: 140,
            //       padding: EdgeInsets.symmetric(horizontal: 10.0),
            //       child: RaisedButton(
            //         shape: RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(18.0)),
            //         color: Colors.white,
            //         child: Container(
            //             padding: EdgeInsets.all(10.0),
            //             child: Image.asset('images/yoga4.PNG')),
            //         onPressed: () =>
            //             onSelectY(context: context, modelName: 'posenet'),
            //       ),
            //     ),
            //   ],
            // ),
            Stack(
              children: <Widget>[
                Container(
                  width: 140,
                  height: 140,
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0)),
                    color: Colors.white,
                    child: Container(
                        padding: EdgeInsets.all(10.0),
                        child: Image.asset('images/arm_press.PNG')),
                    onPressed: () =>
                        onSelectA(context: context, modelName: 'posenet'),
                  ),
                ),
              ],
            )
          ],
        ));
  }
}

void onSelectA({BuildContext context, String modelName}) async {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PushedPageA(
        cameras: cameras,
        title: modelName,
      ),
    ),
  );
}

void onSelectS({BuildContext context, String modelName}) async {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PushedPageS(
        cameras: cameras,
        title: modelName,
      ),
    ),
  );
}

void onSelectY(
    {BuildContext context,
    String modelName,
    Map<String, dynamic> poseData}) async {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) =>
          PushedPageY(cameras: cameras, title: modelName, poseData: poseData),
    ),
  );
}
