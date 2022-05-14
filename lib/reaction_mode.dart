import 'dart:math';

import 'package:flutter/material.dart';
import 'main.dart';
import 'result_page.dart';

class ReactionModePlayGround extends StatefulWidget {
  final ValueChanged<int> parentAction;
  const ReactionModePlayGround({Key? key, required this.parentAction})
      : super(key: key);
  @override
  State<ReactionModePlayGround> createState() => _ReactionModePlayGroundState();
}

class _ReactionModePlayGroundState extends State<ReactionModePlayGround> {
  _ReactionModePlayGroundState() {
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

  late int _number, _controlNumber;
  bool _hasBeenPressed = false;
  @override
  Widget build(BuildContext context) {
    if (sequenceControllerList.isNotEmpty) {
      _controlNumber = sequenceControllerList.first;
    } else {
      _controlNumber = 0;
    }
    return Visibility(
      visible: _hasBeenPressed ? false : true,
      child: Container(
        margin: const EdgeInsets.all(1),
        child: FlatButton(
          color: _controlNumber == _number ? Colors.red : Colors.blueAccent,
          textColor: Colors.white,
          onPressed: () {
            if (_controlNumber == _number) {
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
                            "bestTimeReaction",
                            "Reaction Mode",
                            timePassedToFindNumbers,
                            "/reactionMode",
                            false)));
              }
            }
          },
          child: Visibility(
            visible: _controlNumber == _number ? true : false,
            child: Text(_number.toString()),
          ),
        ),
      ),
    );
  }
}
