import 'package:flutter/material.dart';
import 'package:flutter_qq_red_dot/bezier_painter.dart';

void main() {
//  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft, DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
  runApp(new MyApp());
//  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  bool isMove = false;
  late AnimationController _controller;
  double appBarHeight = 10.0;
  double statusBarHeight = 0.0;
  double screenHeight = 0.0;
  double screenWidth = 0.0;
  Size? end;
  Size? begin;
  Offset? during1;
  Offset? end1;
  late GlobalKey<State<StatefulWidget>> anchorKey;
 late Animation<Size> movement;

  @override
  void initState() {
    super.initState();
    var appBar = AppBar(title: const Text("drag"));
    appBarHeight = appBar.preferredSize.height;
    anchorKey = GlobalKey();
  }

  @override
  Widget build(BuildContext context) {
    statusBarHeight = MediaQuery.of(context).padding.top;
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: Center(
                    child: RaisedButton(
                        onPressed: () {
                          setState(() {
                            RenderBox renderBox = anchorKey.currentContext!
                                .findRenderObject() as RenderBox;
                            var icon = renderBox.localToGlobal(Offset.zero);
                            end = Size(icon.dx + 12,
                                icon.dy - appBarHeight - statusBarHeight - 20);
                            end1 = Offset(icon.dx + 12,
                                icon.dy - appBarHeight - statusBarHeight - 20);
                            during1 = Offset(icon.dx + 12,
                                icon.dy - appBarHeight - statusBarHeight - 20);
                          });
                        },
                        child: const Text('生成消息')),
                  ),
                ),
              ),
              Container(
                color: Colors.blue,
                height: 81,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                        icon: Icon(
                          Icons.android,
                          key: anchorKey,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: null),
                  ],
                ),
              ),
            ],
          ),
          during1 == null
              ? Container()
              : CustomPaint(foregroundPainter: BezierPainter(during1!, end1!)),
          Positioned(
              top: end != null ? end!.height : 0,
              left: end != null ? end!.width : 0,
              child: GestureDetector(
                  child: Container(
                    width: 30,
                    height: 30,
                    color: Colors.transparent,
//                    child: Text('12313'),
                  ),
                  onPanUpdate: (d) {
                    setState(() {
                      double dx = d.globalPosition.dx;
                      double dy =
                          d.globalPosition.dy - appBarHeight - statusBarHeight;
                      during1 = Offset(dx, dy);
                    });
                  },
                  onPanEnd: (d) {
                    begin = Size(during1!.dx, during1!.dy);
                    comeBack();
                    print('onPanEnd : ' + d.toString());
                  })),
        ],
      ),
    );
  }

  comeBack() {
    _controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    _controller.value;
    movement = Tween(
      begin: begin,end: end
    ).animate(CurvedAnimation(parent: _controller, curve: ElasticInCurve(0.6))
    ..addListener(() {
      setState(() {
        during1 = Offset(movement.value.width, movement.value.height);
      });
    }))
    ..addStatusListener((AnimationStatus status) {
      print("-----$status");
    });
    _controller.reset();
    _controller.forward();
  }
}
