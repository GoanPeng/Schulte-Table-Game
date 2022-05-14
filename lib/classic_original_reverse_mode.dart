import 'dart:math';

import 'package:flutter/material.dart';
import 'main.dart';
import 'result_page.dart';

class ClassicOriginalReverseModePlayGround extends StatefulWidget {
  final ValueChanged<int> parentAction;
  const ClassicOriginalReverseModePlayGround(
      {Key? key, required this.parentAction})
      : super(key: key);
  @override
  State<ClassicOriginalReverseModePlayGround> createState() =>
      _ClassicOriginalReverseModePlayGroundState();
}

class _ClassicOriginalReverseModePlayGroundState
    extends State<ClassicOriginalReverseModePlayGround> {
  _ClassicOriginalReverseModePlayGroundState() {
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

  late int _number;
  bool _hasBeenPressed = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(1),
      child: FlatButton(
        splashColor: _hasBeenPressed ? Colors.transparent : Colors.white,
        color: Colors.blueAccent,
        textColor: Colors.white,
        onPressed: () {
          if (sequenceControllerList.last == _number) {
            var sumOfAllExistingElementsInList = 0;
            for (var element in timePassedToFindNumbers) {
              sumOfAllExistingElementsInList += element;
            }
            timePassedToFindNumbers
                .add(globalTimer - sumOfAllExistingElementsInList);
            sequenceControllerList.removeLast();
            if (0 < _number - 1) {
              widget.parentAction(_number - 1);
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
                          "bestTimeClassicOriginalReverse",
                          "Classic Original Reverse Mode",
                          timePassedToFindNumbers,
                          "/classicOriginalReverseMode",
                          true)));
            }
          }
        },
        child: Text(_number.toString()),
      ),
    );
  }
}
