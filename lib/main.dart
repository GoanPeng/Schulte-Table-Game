import 'package:flutter/material.dart';
import 'dart:async';

import 'reaction_mode.dart';
import 'result_page.dart';
import 'classic_light_mode.dart';
import 'classic_light_reverse_mode.dart';
import 'classic_original_mode.dart';
import 'classic_original_reverse_mode.dart';
import 'memory_mode.dart';

const int maxElementNumber = 25;

List<int> timePassedToFindNumbers = [0];
List<int> listUsedForRandomAssignment = [];
List<int> sequenceControllerList = [];
int globalTimer = 0;
int bestTimeReaction = 0,
    bestTimeClassicLight = 0,
    bestTimeClassicLightReverse = 0,
    bestTimeClassicOriginal = 0,
    bestTimeClassicOriginalReverse = 0,
    bestTimeMemory = 0;

bool hasRoundFinished = false;

void main() {
  listMaker();

  runApp(MaterialApp(
    theme: ThemeData(
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.blueAccent),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        ),
      ),
    ),
    initialRoute: "/",
    routes: {
      "/": (context) => const HomeRoute(),
      "/reactionModePlayButton": (context) =>
          PlayButton("Reaction Mode", "/reactionMode", bestTimeReaction),
      "/reactionMode": (context) => const ReactionMode(),
      "/classicLightModePlayButton": (context) => PlayButton(
          "Classic Light Mode", "/classicLightMode", bestTimeClassicLight),
      "/classicLightMode": (context) => const ClassicLightMode(),
      "/classicLightReverseModePlayButton": (context) => PlayButton(
          "Classic Light Reverse Mode",
          "/classicLightReverseMode",
          bestTimeClassicLightReverse),
      "/classicLightReverseMode": (context) => const ClassicLightReverseMode(),
      "/classicOriginalModePlayButton": (context) => PlayButton(
          "Classic Original Mode",
          "/classicOriginalMode",
          bestTimeClassicOriginal),
      "/classicOriginalMode": (context) => const ClassicOriginalMode(),
      "/classicOriginalReverseModePlayButton": (context) => PlayButton(
          "Classic Original Reverse Mode",
          "/classicOriginalReverseMode",
          bestTimeClassicOriginalReverse),
      "/classicOriginalReverseMode": (context) =>
          const ClassicOriginalReverseMode(),
      "/memoryModePlayButton": (context) =>
          PlayButton("Memory Mode", "/memoryMode", bestTimeMemory),
      "/memoryMode": (context) => const MemoryMode(),
    },
  ));
}

class HomeRoute extends StatelessWidget {
  const HomeRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Schulte Table"),
      ),
      body: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        crossAxisCount: 2,
        children: <Widget>[
          TextButton(
            onPressed: () =>
                Navigator.pushNamed(context, "/reactionModePlayButton"),
            child: const Text("Reaction"),
          ),
          TextButton(
            onPressed: () =>
                Navigator.pushNamed(context, "/classicLightModePlayButton"),
            child: const Text("Classic Light"),
          ),
          TextButton(
            onPressed: () => Navigator.pushNamed(
                context, "/classicLightReverseModePlayButton"),
            child: const Text("Classic Light Reverse"),
          ),
          TextButton(
            onPressed: () =>
                Navigator.pushNamed(context, "/classicOriginalModePlayButton"),
            child: const Text("Classic Original"),
          ),
          TextButton(
            onPressed: () => Navigator.pushNamed(
                context, "/classicOriginalReverseModePlayButton"),
            child: const Text(
              "Classic Original Reverse",
              textAlign: TextAlign.center,
            ),
          ),
          TextButton(
            onPressed: () =>
                Navigator.pushNamed(context, "/memoryModePlayButton"),
            child: const Text("Memory"),
          ),
        ],
      ),
    );
  }
}

class PlayButton extends StatefulWidget {
  PlayButton(this.gameModeName, this.routeName, this.bestTime, {Key? key})
      : super(key: key);
  String gameModeName, routeName;
  int bestTime;
  @override
  State<StatefulWidget> createState() {
    return PlayButtonState(gameModeName, routeName, bestTime);
  }
}

class PlayButtonState extends State<PlayButton> {
  PlayButtonState(this.gameModeName, this.routeName, this.bestTime);
  String gameModeName, routeName;
  int bestTime;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () =>
                Navigator.popUntil(context, ModalRoute.withName("/"))),
        title: Text("Play $gameModeName"),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Best Time: ${bestTime / 1000} second(s)"),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, routeName),
              child: const Text("Play!"),
            ),
          ],
        ),
      ),
    );
  }
}

class ReactionMode extends StatefulWidget {
  const ReactionMode({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    timePassedToFindNumbers = [0];
    globalTimer = 0;
    hasRoundFinished = false;
    listMaker();
    return ReactionModeState();
  }
}

class ReactionModeState extends State<ReactionMode> {
  int internalNumberTracker = 1;
  updateInternalNumberTracker(int nextNumber) {
    setState(() {
      internalNumberTracker = nextNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () =>
              Navigator.popUntil(context, ModalRoute.withName("/")),
        ),
        title: const Text("Reaction Mode"),
        backgroundColor: Colors.blue,
      ),
      body: Column(children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                padding: const EdgeInsets.all(10),
                child: Text("Number #: $internalNumberTracker")),
            Container(
                padding: const EdgeInsets.all(10),
                child: const Text("Mode: Reaction")),
            Container(
                width: 100,
                padding: const EdgeInsets.all(10),
                child: TimerManagement("bestTimeReaction", "Reaction Mode",
                    timePassedToFindNumbers, "/reactionMode", false)),
          ],
        ),
        Flexible(
          child: GridView.count(
              primary: false,
              padding: const EdgeInsets.all(5),
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              crossAxisCount: 5,
              children: List.generate(
                  maxElementNumber,
                  (index) => ReactionModePlayGround(
                      parentAction: updateInternalNumberTracker))),
        ),
      ]),
    );
  }
}

class ClassicLightMode extends StatefulWidget {
  const ClassicLightMode({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    timePassedToFindNumbers = [0];
    globalTimer = 0;
    hasRoundFinished = false;
    listMaker();
    return ClassicLightModeState();
  }
}

class ClassicLightModeState extends State<ClassicLightMode> {
  int internalNumberTracker = 1;
  updateInternalNumberTracker(int nextNumber) {
    setState(() {
      internalNumberTracker = nextNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () =>
              Navigator.popUntil(context, ModalRoute.withName("/")),
        ),
        title: const Text("Classic Light Mode"),
        backgroundColor: Colors.blue,
      ),
      body: Column(children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                padding: const EdgeInsets.all(10),
                child: Text("Number #: $internalNumberTracker")),
            Container(
                padding: const EdgeInsets.all(10),
                child: const Text("Mode: Classic Light")),
            Container(
                width: 100,
                padding: const EdgeInsets.all(10),
                child: TimerManagement(
                    "bestTimeClassicLight",
                    "Classic Light Mode",
                    timePassedToFindNumbers,
                    "/classicLightMode",
                    false)),
          ],
        ),
        Flexible(
          child: GridView.count(
              primary: false,
              padding: const EdgeInsets.all(5),
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              crossAxisCount: 5,
              children: List.generate(
                  maxElementNumber,
                  (index) => ClassicLightModePlayGround(
                      parentAction: updateInternalNumberTracker))),
        ),
      ]),
    );
  }
}

class ClassicLightReverseMode extends StatefulWidget {
  const ClassicLightReverseMode({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    timePassedToFindNumbers = [0];
    globalTimer = 0;
    hasRoundFinished = false;
    listMaker();
    return ClassicLightReverseModeState();
  }
}

class ClassicLightReverseModeState extends State<ClassicLightReverseMode> {
  int internalNumberTracker = 25;
  updateInternalNumberTracker(int nextNumber) {
    setState(() {
      internalNumberTracker = nextNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () =>
              Navigator.popUntil(context, ModalRoute.withName("/")),
        ),
        title: const Text("Classic Light Reverse Mode"),
        backgroundColor: Colors.blue,
      ),
      body: Column(children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                padding: const EdgeInsets.all(10),
                child: Text("Number #: $internalNumberTracker")),
            Container(
                padding: const EdgeInsets.all(10),
                child: const Text("Mode: Classic Light Reverse")),
            Container(
                width: 100,
                padding: const EdgeInsets.all(10),
                child: TimerManagement(
                    "bestTimeClassicLightReverse",
                    "Classic Light Reverse Mode",
                    timePassedToFindNumbers,
                    "/classicLightReverseMode",
                    true)),
          ],
        ),
        Flexible(
          child: GridView.count(
              primary: false,
              padding: const EdgeInsets.all(5),
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              crossAxisCount: 5,
              children: List.generate(
                  maxElementNumber,
                  (index) => ClassicLightReverseModePlayGround(
                      parentAction: updateInternalNumberTracker))),
        ),
      ]),
    );
  }
}

class ClassicOriginalMode extends StatefulWidget {
  const ClassicOriginalMode({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    timePassedToFindNumbers = [0];
    globalTimer = 0;
    hasRoundFinished = false;
    listMaker();
    return ClassicOriginalModeState();
  }
}

class ClassicOriginalModeState extends State<ClassicOriginalMode> {
  int internalNumberTracker = 1;
  updateInternalNumberTracker(int nextNumber) {
    setState(() {
      internalNumberTracker = nextNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () =>
              Navigator.popUntil(context, ModalRoute.withName("/")),
        ),
        title: const Text("Classic Original Mode"),
        backgroundColor: Colors.blue,
      ),
      body: Column(children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                padding: const EdgeInsets.all(10),
                child: Text("Number #: $internalNumberTracker")),
            Container(
                padding: const EdgeInsets.all(10),
                child: const Text("Mode: Classic Original")),
            Container(
                width: 100,
                padding: const EdgeInsets.all(10),
                child: TimerManagement(
                    "bestTimeClassicOriginal",
                    "Classic Original Mode",
                    timePassedToFindNumbers,
                    "/classicOriginalMode",
                    false)),
          ],
        ),
        Flexible(
          child: GridView.count(
              primary: false,
              padding: const EdgeInsets.all(5),
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              crossAxisCount: 5,
              children: List.generate(
                  maxElementNumber,
                  (index) => ClassicOriginalModePlayGround(
                      parentAction: updateInternalNumberTracker))),
        ),
      ]),
    );
  }
}

class ClassicOriginalReverseMode extends StatefulWidget {
  const ClassicOriginalReverseMode({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    timePassedToFindNumbers = [0];
    globalTimer = 0;
    hasRoundFinished = false;
    listMaker();
    return ClassicOriginalReverseModeState();
  }
}

class ClassicOriginalReverseModeState
    extends State<ClassicOriginalReverseMode> {
  int internalNumberTracker = 25;
  updateInternalNumberTracker(int nextNumber) {
    setState(() {
      internalNumberTracker = nextNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () =>
              Navigator.popUntil(context, ModalRoute.withName("/")),
        ),
        title: const Text("Classic Original Reverse Mode"),
        backgroundColor: Colors.blue,
      ),
      body: Column(children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                padding: const EdgeInsets.all(10),
                child: Text("Number #: $internalNumberTracker")),
            Container(
                padding: const EdgeInsets.all(10),
                child: const Text(
                  "Mode: Classic Original Reverse",
                  style: TextStyle(fontSize: 12),
                )),
            Container(
                width: 100,
                padding: const EdgeInsets.all(10),
                child: TimerManagement(
                    "bestTimeClassicOriginalReverse",
                    "Classic Original Reverse Mode",
                    timePassedToFindNumbers,
                    "/classicOriginalReverseMode",
                    true)),
          ],
        ),
        Flexible(
          child: GridView.count(
              primary: false,
              padding: const EdgeInsets.all(5),
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              crossAxisCount: 5,
              children: List.generate(
                  maxElementNumber,
                  (index) => ClassicOriginalReverseModePlayGround(
                      parentAction: updateInternalNumberTracker))),
        ),
      ]),
    );
  }
}

class MemoryMode extends StatefulWidget {
  const MemoryMode({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    timePassedToFindNumbers = [0];
    globalTimer = 0;
    hasRoundFinished = false;
    listMaker();
    return MemoryModeState();
  }
}

class MemoryModeState extends State<MemoryMode> {
  int internalNumberTracker = 1;
  updateInternalNumberTracker(int nextNumber) {
    setState(() {
      internalNumberTracker = nextNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () =>
              Navigator.popUntil(context, ModalRoute.withName("/")),
        ),
        title: const Text("Memory Mode"),
        backgroundColor: Colors.blue,
      ),
      body: Column(children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                padding: const EdgeInsets.all(10),
                child: Text("Number #: $internalNumberTracker")),
            Container(
                padding: const EdgeInsets.all(10),
                child: const Text("Mode: Memory")),
            Container(
                width: 100,
                padding: const EdgeInsets.all(10),
                child: TimerManagement("bestTimeMemory", "Memory Mode",
                    timePassedToFindNumbers, "/memoryMode", false)),
          ],
        ),
        Flexible(
          child: GridView.count(
              primary: false,
              padding: const EdgeInsets.all(5),
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              crossAxisCount: 5,
              children: List.generate(
                  maxElementNumber,
                  (index) => MemoryModePlayGround(
                      parentAction: updateInternalNumberTracker))),
        ),
      ]),
    );
  }
}

void listMaker() {
  listUsedForRandomAssignment.clear();
  sequenceControllerList.clear();
  for (int i = 0; i < maxElementNumber; i++) {
    listUsedForRandomAssignment.add(i + 1);
    sequenceControllerList.add(i + 1);
  }
}

class TimerManagement extends StatefulWidget {
  String bestTimeName;
  List<int> list;
  String previousGameModeRoute, gameModeName;
  bool isReverse;
  TimerManagement(this.bestTimeName, this.gameModeName, this.list,
      this.previousGameModeRoute, this.isReverse,
      {Key? key})
      : super(key: key);
  @override
  State<TimerManagement> createState() => _TimerManagementState();
}

class _TimerManagementState extends State<TimerManagement> {
  _TimerManagementState();
  @override
  void initState() {
    Timer.periodic(const Duration(milliseconds: 1), (callBack) {
      setState(() {
        if (hasRoundFinished) {
          callBack.cancel();
        }
        globalTimer += 1;
        if (!hasRoundFinished && globalTimer == 60000) {
          for (int i = widget.list.length; i < maxElementNumber; i++) {
            widget.list.add(0);
          }
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResultPage(
                  widget.bestTimeName,
                  widget.gameModeName,
                  widget.list,
                  widget.previousGameModeRoute,
                  widget.isReverse),
            ),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text((globalTimer / 1000).toStringAsFixed(3));
  }
}
