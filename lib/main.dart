import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

/// The root widget of the application.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Padding(
        padding: EdgeInsets.all(32.0),
        child: SquareAnimation(),
      ),
    );
  }
}

/// A StatefulWidget that manages the animation of a red square moving left and right.
class SquareAnimation extends StatefulWidget {
  const SquareAnimation({super.key});

  @override
  State<SquareAnimation> createState() {
    return SquareAnimationState();
  }
}

/// The state class for [SquareAnimation]. It manages the position of the square and its animation.
class SquareAnimationState extends State<SquareAnimation> {
  static const _squareSize = 50.0;

  // The current horizontal position of the square.
  double _squarePosition = 0.0;

  // A flag to track whether the square is currently moving.
  bool _isMoving = false;

  @override
  void initState() {
    super.initState();

    // Use [addPostFrameCallback] to calculate the center position of the square after the first frame is rendered.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final screenWidth = MediaQuery.of(context).size.width - 64;

      final centerPosition = (screenWidth - _squareSize) / 2;

      setState(() {
        _squarePosition = centerPosition;
      });
    });
  }

  /// Moves the square to the specified target position.
  ///
  /// - [targetPosition]: The horizontal position to which the square should move.
  void _moveSquare(double targetPosition) {
    // If the square is already moving, do nothing.
    if (_isMoving) return;

    // Set the [_isMoving] flag to true to disable the buttons during the animation.
    setState(() {
      _isMoving = true;
    });

    // After end of movement, update the square's position.
    setState(() {
      _squarePosition = targetPosition;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width - 64;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedContainer(
          duration: const Duration(seconds: 1),
          width: _squareSize,
          height: _squareSize,
          decoration: BoxDecoration(
            color: Colors.red,
            border: Border.all(),
          ),
          margin: EdgeInsets.only(left: _squarePosition),
          //Enable buttons when movement is finished.
          onEnd: () {
            setState(() {
              _isMoving = false;
            });
          },
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _isMoving || _squarePosition == 0
                  ? null // Disable the button if the square is moving or already at the leftmost position.
                  : () {
                      _moveSquare(0); // Move the square to the leftmost position.
                    },
              child: const Text('Left'),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: _isMoving || _squarePosition == screenWidth - _squareSize
                  ? null // Disable the button if the square is moving or already at the rightmost position.
                  : () {
                      _moveSquare(screenWidth - _squareSize); // Move the square to the rightmost position.
                    },
              child: const Text('Right'),
            ),
          ],
        ),
      ],
    );
  }
}
