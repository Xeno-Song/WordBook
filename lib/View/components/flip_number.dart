import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FlipNumber extends StatefulWidget {
  FlipNumber({super.key});

  @override
  State<StatefulWidget> createState() {
    return _FlipNumberState();
  }
}

class _FlipNumberState extends State<FlipNumber> with TickerProviderStateMixin {
  AnimationController? _controller;
  Animation? _animation;
  // int _currentIndex;
  // bool _isReversePhase;
  // bool _isStreamMode;
  // bool _running;
  final _perspective = 0.003;
  final _zeroAngle = 0.0001;

  final double pi = 3.141592;

  final double height = 50;
  final double width = 30;
  final int animationTime = 500;
  int _flipStage = 0;
  int _oldNumber = 0;
  int _newNumber = 1;
  // int _loop;
  // T _currentValue, _nextValue;
  // Timer _timer;

  // Widget _child1, _child2;
  // Widget _upperChild1, _upperChild2;
  // Widget _lowerChild1, _lowerChild2;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(duration: Duration(milliseconds: animationTime), vsync: this)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          if (_flipStage == 0) {
            _flipStage = 1;
            _controller?.reverse(from: animationTime.toDouble());
            // _controller?.forward(from: 0.0);
          }
        }
        if (status == AnimationStatus.dismissed) {
          if (_flipStage == 1) {
            _flipStage = 2;
            setState(() => _oldNumber = _newNumber);
          }
        }
      })
      ..addListener(() {
        setState(() {
          // _running = true;
        });
      });
    _animation = Tween(begin: _zeroAngle, end: pi / 2).animate(_controller!);
    _controller?.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    print("Stage : ${_flipStage} : ${_animation?.value}");

    return AnimatedBuilder(
      animation: _animation!,
      builder: (context, child) {
        return SizedBox(
          width: width,
          height: height,
          child: Stack(
            children: [
              _FlipNumberIndex(
                value: _oldNumber,
                width: width,
                height: height / 2,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, height / 2, 0, 0),
                child: Transform(
                  alignment: Alignment.topCenter,
                  transform: Matrix4.identity()
                    //..translate(0, -height / 2, 0)
                    ..rotateX(_flipStage == 1 ? _animation?.value : pi / 2)
                    //..translate(0, height / 2, 0)
                    ..setEntry(3, 2, _perspective),
                  child: Container(
                    transform: Matrix4.translationValues(0.0, -height / 2, 0.0),
                    child: _FlipNumberIndex(
                      value: _newNumber,
                      width: width,
                      height: height / 2,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, height / 2, 0, 0),
                child: _FlipNumberIndex(
                  value: _newNumber,
                  width: width,
                  height: height / 2,
                  isUpper: false,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, height / 2, 0, 0),
                child: Transform(
                  alignment: Alignment.topCenter,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, _perspective)
                    ..rotateX(_flipStage == 0 ? _animation?.value : pi / 2),
                  child: _FlipNumberIndex(
                    value: _oldNumber,
                    width: width,
                    height: height / 2,
                    isUpper: false,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FlipNumberIndex extends StatelessWidget {
  const _FlipNumberIndex({
    super.key,
    required this.value,
    required this.width,
    required this.height,
    this.isUpper = true,
    this.outlineColor = Colors.white,
  });
  final int value;
  final double width;
  final double height;
  final bool isUpper;
  final Color outlineColor;

  static const double _topOffsetRatio = 0.2;
  static const double _textSizeRatio = 1.2;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            width: 1,
            color: outlineColor,
          ),
          right: BorderSide(
            width: 1,
            color: outlineColor,
          ),
          top: isUpper
              ? BorderSide(
                  width: 1,
                  color: outlineColor,
                )
              : BorderSide.none,
          bottom: isUpper
              ? BorderSide.none
              : BorderSide(
                  width: 1,
                  color: outlineColor,
                ),
        ),
        color: const Color.fromARGB(0xFF, 0x10, 0x10, 0x10),
      ),
      alignment: Alignment.center,
      child: Container(
        height: height,
        alignment: Alignment.center,
        child: Stack(
          // overflow: Overflow.clip,
          children: [
            Positioned(
              top: isUpper ? height * _topOffsetRatio : -(height - height * _topOffsetRatio),
              width: width,
              child: Center(
                child: Text(
                  value.toString(),
                  style: TextStyle(
                    fontSize: height * _textSizeRatio,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      // Positioned(
      //   bottom: 0,
      //   child: Text(
      //     value.toString(),
      //     style: TextStyle(
      //       color: Colors.white,
      //       fontSize: height * 1,
      //     ),
      //   ),
      // ),
    );
  }
}
