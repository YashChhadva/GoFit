import 'package:flutter/material.dart';
import 'main.dart' as math;

class BMIPage extends StatefulWidget {
  @override
  _BMIPageState createState() => _BMIPageState();
}

class _BMIPageState extends State<BMIPage> {
  // String gender = 'Male';
  final GlobalKey<FormState> _formKey = GlobalKey();
  double bmi = 0.0;
  Map<String, String> _bmidata = {
    'gender': 'Male',
    'weight': '',
    'height': '',
    'weightunit': 'Kgs',
    'heightunit': 'Mtr'
  };

  void _showDialog(double index) {
    String message = '';
    String picture = '';
    if (index < 18.5) {
      message = 'You are underweight but it is not the end of the world';
      picture = 'images/underweightpic.png';
    } else if (index > 25) {
      message = 'You are overweight but it is not the end of the world';
      picture = 'images/overweightpic.png';
    } else {
      message = 'You look fit!! Keep going';
      picture = 'images/fitpic.png';
    }
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: Color.fromRGBO(232, 218, 239, 1),
        title: Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.amberAccent),
          padding: EdgeInsets.all(10),
          child: Text(
            'BMI: ' + index.toStringAsFixed(2),
            textAlign: TextAlign.center,
          ),
        ),
        content: Container(
          height: 260,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                  child: Image.asset(picture, fit: BoxFit.contain),
                  height: 150),
              Text(
                message,
                textAlign: TextAlign.center,
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Color.fromRGBO(127, 179, 213, 0.6)),
                child: FlatButton(
                  child: Text(
                    'Okay',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200),
                  ),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    if (_bmidata['heightunit'] == 'Inches') {
      _bmidata['height'] =
          (double.parse(_bmidata['height']) * 0.0254).toString();
    } else if (_bmidata['heightunit'] == 'Feet') {
      _bmidata['height'] =
          (double.parse(_bmidata['height']) * 0.3048).toString();
    }

    if (_bmidata['weightunit'] == 'lbs') {
      _bmidata['weight'] =
          (double.parse(_bmidata['weight']) * 0.453592).toString();
    }

    setState(() {
      bmi = double.parse(_bmidata['weight']) /
          (double.parse(_bmidata['height']) * double.parse(_bmidata['height']));
    });
    _showDialog(bmi);
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Color.fromRGBO(32, 26, 48, 1),
        body: Container(
          width: double.infinity,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 30),
                    child: Text(
                      "Let's Warm Up",
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: Color.fromRGBO(13, 245, 227, 1),
                    ),
                    child: DropdownButton(
                        value: _bmidata['gender'],
                        icon: Icon(Icons.arrow_downward),
                        iconSize: 24,
                        items: [
                          DropdownMenuItem(child: Text('Male'), value: 'Male'),
                          DropdownMenuItem(
                              child: Text('Female'), value: 'Female')
                        ],
                        onChanged: (String newValue) {
                          setState(() {
                            _bmidata['gender'] = newValue;
                          });
                        }),
                  ),
                  Text(
                    "Weight",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: screen.width * 0.5,
                        height: 60,
                        margin: EdgeInsets.only(top: 15),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            color: Color.fromRGBO(56, 48, 76, 1)),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            focusColor: Colors.white54,
                            labelStyle: TextStyle(color: Colors.white),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            contentPadding: EdgeInsets.only(
                                left: 15, bottom: 11, top: 11, right: 15),
                          ),
                          // obscureText: true,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'invalid input';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _bmidata['weight'] = value.toString();
                          },
                        ),
                      ),
                      SizedBox(
                        width: 40,
                      ),
                      Container(
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: Color.fromRGBO(56, 48, 76, 1),
                        ),
                        child: DropdownButton(
                            underline: Container(
                                height: 2,
                                color: Color.fromRGBO(56, 48, 76, 1)),
                            dropdownColor: Color.fromRGBO(56, 48, 76, 1),
                            value: _bmidata['weightunit'],
                            icon: Icon(Icons.arrow_drop_down_circle,
                                color: Color.fromRGBO(13, 245, 227, 1)),
                            iconSize: 24,
                            items: [
                              DropdownMenuItem(
                                  child: Text(
                                    'Kgs',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  value: 'Kgs'),
                              DropdownMenuItem(
                                  child: Text(
                                    'lbs',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  value: 'lbs')
                            ],
                            onChanged: (String newValue) {
                              setState(() {
                                _bmidata['weightunit'] = newValue;
                              });
                            }),
                      ),
                    ],
                  ),
                  Text(
                    "Height",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: screen.width * 0.5,
                        height: 60,
                        margin: EdgeInsets.only(top: 15),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            color: Color.fromRGBO(56, 48, 76, 1)),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            focusColor: Colors.white54,
                            labelStyle: TextStyle(color: Colors.white),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            contentPadding: EdgeInsets.only(
                                left: 15, bottom: 11, top: 11, right: 15),
                          ),
                          // obscureText: true,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'invalid input';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _bmidata['height'] = value;
                          },
                        ),
                      ),
                      SizedBox(width: 40),
                      Container(
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: Color.fromRGBO(56, 48, 76, 1),
                        ),
                        child: DropdownButton(
                            underline: Container(
                                height: 2,
                                color: Color.fromRGBO(56, 48, 76, 1)),
                            dropdownColor: Color.fromRGBO(56, 48, 76, 1),
                            value: _bmidata['heightunit'],
                            icon: Icon(
                              Icons.arrow_drop_down_circle,
                              color: Color.fromRGBO(13, 245, 227, 1),
                            ),
                            iconSize: 24,
                            items: [
                              DropdownMenuItem(
                                  child: Text(
                                    'Mtr',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  value: 'Mtr'),
                              DropdownMenuItem(
                                  child: Text(
                                    'Inches',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  value: 'Inches'),
                              DropdownMenuItem(
                                  child: Text(
                                    'Feet',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  value: 'Feet')
                            ],
                            onChanged: (String newValue) {
                              setState(() {
                                _bmidata['heightunit'] = newValue;
                              });
                            }),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 15),
                    child: RaisedButton(
                      // padding : EdgeInsets.all(10),
                      child: Text('Calculate BMI'),
                      onPressed: _submit,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 15.0),
                      color: Color.fromRGBO(13, 245, 227, 1),
                      textColor: Colors.black,
                    ),
                  ),
                  Text(
                    'BMI',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  Text(
                    bmi.toStringAsFixed(2),
                    // _bmidata['height'],
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
