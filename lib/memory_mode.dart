import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'main.dart';
import 'result_page.dart';

class MemoryModePlayGround extends StatefulWidget {
  final ValueChanged<int> parentAction;
  const MemoryModePlayGround({Key? key, required this.parentAction})
      : super(key: key);
  @override
  State<MemoryModePlayGround> createState() => _MemoryModePlayGroundState();
}

class _MemoryModePlayGroundState extends State<MemoryModePlayGround> {
  _MemoryModePlayGroundState() {
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
  bool _hasBeenPressed = false,
      _hasBeenMisclicked = true,
      initialTimerController = true,
      allButtonsLocked = true;

  @override
  Widget build(BuildContext context) {
    if (initialTimerController) {
      Timer(const Duration(seconds: 3), () {
        setState(() {
          _hasBeenMisclicked = false;
          allButtonsLocked = false;
        });
      });
      initialTimerController = false;
    }

    return Visibility(
      visible: _hasBeenPressed ? false : true,
      child: Container(
        margin: const EdgeInsets.all(1),
        child: TextButton(
          onPressed: () {
            if (!allButtonsLocked) {
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
                              "bestTimeMemory",
                              "Memory Mode",
                              timePassedToFindNumbers,
                              "/memoryMode",
                              false)));
                }
              } else {
                setState(() {
                  _hasBeenMisclicked = true;
                });
                Timer(const Duration(seconds: 3), () {
                  setState(() {
                    _hasBeenMisclicked = false;
                  });
                });
              }
            }
          },
          child: Visibility(
            visible: _hasBeenMisclicked ? true : false,
            child: Text(_number.toString()),
          ),
        ),
      ),
    );
  }
}
