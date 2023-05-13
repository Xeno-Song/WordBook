import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HorizontalFlipNumberController extends ValueNotifier<int> {
  HorizontalFlipNumberController(super.value);
}

class HorizontalFlipNumber extends StatefulWidget {
  const HorizontalFlipNumber({
    super.key,
    required this.digits,
    required this.height,
    required this.width,
    required this.gapBetweenDigits,
    required this.controller,
  });

  final int digits;
  final double height;
  final double width;
  final double gapBetweenDigits;
  final HorizontalFlipNumberController controller;

  @override
  State<StatefulWidget> createState() {
    return _HorizontalFlipNumberState();
  }
}

class _HorizontalFlipNumberState extends State<HorizontalFlipNumber> {
  int value = 0;
  List<FlipNumberController> _numberController = List<FlipNumberController>.empty();

  @override
  void initState() {
    super.initState();

    _numberController = List<FlipNumberController>.generate(widget.digits, (index) => FlipNumberController(0));
    value = widget.controller.value;
    widget.controller.addListener(_updateValue);
  }

  void _updateValue() {
    print("AA ${widget.controller.value}");
    // setState(() => value = widget.controller.value);
    for (int i = 0; i < widget.digits; ++i) {
      _numberController[i].value = ((widget.controller.value / pow(10, widget.digits - i - 1)) % 10).floor();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: List<Widget>.generate(
        widget.digits,
        (index) {
          return Padding(
            padding: EdgeInsets.fromLTRB(0, 0, widget.gapBetweenDigits, 0),
            child: FlipNumber(
              // value: (value / pow(10, widget.digits - index - 1)).floor() % 10,
              controller: _numberController[index],
              height: 50,
              width: 30,
            ),
          );
        },
      ),
    );
  }
}

class FlipNumberController extends ValueNotifier<int> {
  FlipNumberController(super.value);
}

class FlipNumber extends StatefulWidget {
  const FlipNumber({
    super.key,
    // required this.value,
    required this.width,
    required this.height,
    required this.controller,
  });

  // final int value;
  final double width;
  final double height;
  final FlipNumberController controller;

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

  final int animationTime = 80;
  // final int targetNumber = 9;
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
            setState(() {
              _oldNumber = _newNumber;
              onNumberChanged();
              // changeToNewNumber((_newNumber + 1) % 10);
            });
          }
        }
      });
    _animation = Tween(begin: _zeroAngle, end: pi / 2).animate(_controller!);
    _controller?.forward(from: 0.0);
    widget.controller.addListener(onNumberChanged);
  }

  void onNumberChanged() {
    if (_flipStage != 2) return;

    if (widget.controller.value != _oldNumber) {
      int nextNumber = (_oldNumber + 1) % 10;
      int numberDiff = (widget.controller.value + 10 - nextNumber) % 10;
      int animationDuration = animationTime;

      switch (numberDiff) {
        case 2:
          animationDuration = (animationDuration * 1.5).ceil();
          break;
        case 1:
          animationDuration = (animationDuration * 2);
          break;
        case 0:
          animationDuration = (animationDuration * 3).ceil();
          break;
      }

      _controller?.duration = Duration(milliseconds: animationDuration);
      changeToNewNumber((_oldNumber + 1) % 10);
    }
  }

  void changeToNewNumber(int newNumber) {
    _newNumber = newNumber;
    _flipStage = 0;
    _controller?.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    // print("Stage : ${_flipStage} : ${_animation?.value} / $_oldNumber,$_newNumber");

    return AnimatedBuilder(
      animation: _animation!,
      builder: (context, child) {
        return SizedBox(
          width: widget.width,
          height: widget.height,
          child: Stack(
            children: [
              _FlipNumberIndex(
                // upper new
                value: _newNumber,
                width: widget.width,
                height: widget.height / 2,
              ),
              Padding(
                // upper old
                padding: EdgeInsets.fromLTRB(0, widget.height / 2, 0, 0),
                child: Transform(
                  alignment: Alignment.topCenter,
                  transform: Matrix4.identity()
                    ..rotateX(_flipStage == 0 ? _animation?.value : pi / 2)
                    ..setEntry(3, 2, _perspective),
                  child: Container(
                    transform: Matrix4.translationValues(0.0, -widget.height / 2, 0.0),
                    child: _FlipNumberIndex(
                      value: _oldNumber,
                      width: widget.width,
                      height: widget.height / 2,
                    ),
                  ),
                ),
              ),
              Padding(
                // bottom old
                padding: EdgeInsets.fromLTRB(0, widget.height / 2, 0, 0),
                child: _FlipNumberIndex(
                  value: _oldNumber,
                  width: widget.width,
                  height: widget.height / 2,
                  isUpper: false,
                ),
              ),
              Padding(
                // bottom new
                padding: EdgeInsets.fromLTRB(0, widget.height / 2, 0, 0),
                child: Transform(
                  alignment: Alignment.topCenter,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, _perspective)
                    ..rotateX(_flipStage == 1 ? _animation?.value : pi / 2),
                  child: _FlipNumberIndex(
                    value: _newNumber,
                    width: widget.width,
                    height: widget.height / 2,
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

  static const double _topOffsetRatio = 0.1;
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
