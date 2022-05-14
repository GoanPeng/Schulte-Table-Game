import 'dart:math';

import 'package:flutter/material.dart';
import 'main.dart';
import 'result_page.dart';

class ClassicLightModePlayGround extends StatefulWidget {
  final ValueChanged<int> parentAction;
  const ClassicLightModePlayGround({Key? key, required this.parentAction})
      : super(key: key);
  @override
  State<ClassicLightModePlayGround> createState() =>
      _ClassicLightModePlayGroundState();
}

class _ClassicLightModePlayGroundState
    extends State<ClassicLightModePlayGround> {
  late int _number;
  bool _hasBeenPressed = false;

  _ClassicLightModePlayGroundState() {
    var random = Random();
    do {
      var checkIsValidInList = random.nextInt(maxElementNumber) + 1;
      if (listUsedForRandomAssignment.contains(checkIsValidInList)) {
        _number = checkIsValidInList;
        listUsedForRandomAssignment.remove(checkIsValidInList);
        break;
      }
    } while (true);
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: _hasBeenPressed ? false : true,
      child: Container(
        margin: const EdgeInsets.all(1),
        child: TextButton(
          // color: Colors.blueAccent,
          // textColor: Colors.white,
          onPressed: () {
            if (sequenceControllerList.first == _number) {
              var sumOfAllExistingElementsInList = 0;
              for (var element in timePassedToFindNumbers) {
                sumOfAllExistingElementsInList += element;
              }
              timePassedToFindNumbers
                  .add(globalTimer - sumOfAllExistingElementsInList);
              sequenceControllerList.removeAt(0);
              if (_number + 1 < maxElementNumber + 1) {
                widget.parentAction(_number + 1);
              }

              setState(() {
                _hasBeenPressed = !_hasBeenPressed;
              });
              if (sequenceControllerList.isEmpty) {
                hasRoundFinished = true;
                timePassedToFindNumbers.removeAt(0);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ResultPage(
                            "bestTimeClassicLight",
                            "Classic Light Mode",
                            timePassedToFindNumbers,
                            "/classicLightMode",
                            false)));
              }
            }
          },
          child: Text(_number.toString()),
        ),
      ),
    );
  }
}
