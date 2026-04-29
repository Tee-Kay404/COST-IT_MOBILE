import 'package:flutter/material.dart';

class BowlClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    // Start at top-left
    path.lineTo(0, size.height * 0.2);

    // Curve to top-right (bowl shape)
    path.quadraticBezierTo(
      size.width / 2,
      size.height * 0.5, // control point (middle, deeper curve)
      size.width,
      size.height * 0.2, // end point (top-right)
    );

    // Right side down
    path.lineTo(size.width, size.height);
    // Bottom side
    path.lineTo(0, size.height);
    // Close the shape
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class BowlContainerDemo extends StatelessWidget {
  const BowlContainerDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: Align(
        alignment: Alignment.bottomCenter,
        child: ClipPath(
          clipper: BowlClipper(),
          child: Container(
            width: double.infinity,
            height: 400,
            color: Colors.blue,
            child: Center(
              child: Text(
                "Bowl Shape",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  final double waveHeight;

  WaveClipper({this.waveHeight = 40});

  @override
  Path getClip(Size size) {
    Path path = Path();

    // Start bottom-left
    path.moveTo(0, size.height);

    // Left side up
    path.lineTo(0, size.height * 0.3);

    // First curve (up)
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.3 - waveHeight, // control point
      size.width * 0.5,
      size.height * 0.3, // end point
    );

    // Second curve (down)
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.3 + waveHeight, // control point
      size.width,
      size.height * 0.3, // end point
    );

    // Right side down
    path.lineTo(size.width, size.height);

    // Close path
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class ParabolaClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    // Start bottom-left
    path.moveTo(0, size.height);

    // Left edge up
    path.lineTo(0, size.height * 0.3);

    // Parabolic curve across the top
    path.quadraticBezierTo(
      size.width / 2,
      0, // control point (middle top)
      size.width,
      size.height * 0.3, // end point (top-right corner)
    );

    // Right edge down
    path.lineTo(size.width, size.height);

    // Close shape
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class EllipseClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path clippedPath = Path();
    double curveDistance = 40;

    clippedPath.moveTo(0, size.height * 0.4);
    clippedPath.lineTo(0, size.height - curveDistance);
    clippedPath.quadraticBezierTo(
      1,
      size.height - 1,
      0 + curveDistance,
      size.height,
    );
    clippedPath.lineTo(size.width - curveDistance, size.height);
    clippedPath.quadraticBezierTo(
      size.width + 1,
      size.height - 1,
      size.width,
      size.height - curveDistance,
    );
    clippedPath.lineTo(size.width, 0 + curveDistance);
    clippedPath.quadraticBezierTo(
      size.width - 1,
      0,
      size.width - curveDistance - 5,
      0 + curveDistance / 3,
    );
    clippedPath.lineTo(curveDistance, size.height * 0.29);
    clippedPath.quadraticBezierTo(
      1,
      (size.height * 0.30) + 10,
      0,
      size.height * 0.4,
    );

    return clippedPath;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height * 0.85);

    // Curve on the left side
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height,
      size.width * 0.5,
      size.height * 0.85,
    );

    // Curve on the right side
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.70,
      size.width,
      size.height * 0.85,
    );

    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class PurpleHeader extends StatelessWidget {
  final String title;
  const PurpleHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: HeaderClipper(),
      child: Container(
        height: 120,
        width: double.infinity,
        color: Colors.purple,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 16, top: 40),
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class ExamplePage extends StatelessWidget {
  const ExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: const [PurpleHeader(title: "Forgot Password")]),
    );
  }
}

class ScissorClipper extends CustomClipper<Path> {
  final double cutSize;

  ScissorClipper({this.cutSize = 10.0});

  @override
  Path getClip(Size size) {
    final path = Path();

    // Start from the top left corner
    path.moveTo(0, 0);

    // Top edge with cuts
    for (double x = 0; x <= size.width; x += cutSize * 2) {
      path.lineTo(x + cutSize, 0);
      path.lineTo(x + cutSize * 2, cutSize);
    }

    // Right edge with cuts
    for (double y = 0; y <= size.height; y += cutSize * 2) {
      path.lineTo(size.width, y + cutSize);
      path.lineTo(size.width - cutSize, y + cutSize * 2);
    }

    // Bottom edge with cuts
    for (double x = size.width; x >= 0; x -= cutSize * 2) {
      path.lineTo(x - cutSize, size.height);
      path.lineTo(x - cutSize * 2, size.height - cutSize);
    }

    // Left edge with cuts
    for (double y = size.height; y >= 0; y -= cutSize * 2) {
      path.lineTo(0, y - cutSize);
      path.lineTo(cutSize, y - cutSize * 2);
    }

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class ScissorClipperExample extends StatelessWidget {
  const ScissorClipperExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ClipPath(
          clipper: ScissorClipper(),
          child: Container(
            width: 300,
            height: 300,
            color: Colors.blue, // or any color you prefer
            child: Center(
              child: Text(
                'Scissor Cut!',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void main() => runApp(MaterialApp(home: ScissorClipperExample()));

class BottomScissorClipper extends CustomClipper<Path> {
  final double cutSize;

  BottomScissorClipper({this.cutSize = 10.0});

  @override
  Path getClip(Size size) {
    final path = Path();

    // Start top-left
    path.moveTo(0, 0);
    path.lineTo(size.width, 0); // top edge
    path.lineTo(size.width, size.height); // right edge

    // bottom edge with cuts
    for (double x = size.width; x >= 0; x -= cutSize * 2) {
      path.lineTo(x - cutSize, size.height - cutSize);
      path.lineTo(x - cutSize * 2, size.height);
    }

    path.lineTo(0, size.height); // left-bottom
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class ScissorsClipperExample extends StatelessWidget {
  const ScissorsClipperExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            ClipPath(
              clipper: BottomScissorClipper(cutSize: 15),
              child: Container(
                width: 300,
                height: 200,
                color: Colors.blue,
                child: const Center(
                  child: Text(
                    'Bottom Cut Only',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              right: 10,
              child: Image.asset(
                'assets/images/medal.png',
                width: 50,
                height: 50,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
