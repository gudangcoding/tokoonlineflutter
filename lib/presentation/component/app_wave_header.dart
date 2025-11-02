import 'package:flutter/material.dart';

class AppWaveHeader extends StatelessWidget {
  final double height;
  final Widget? logo;

  const AppWaveHeader({super.key, this.height = 200, this.logo});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return SizedBox(
      width: double.infinity,
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipPath(
            clipper: _WaveClipper(offset: 0),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    primary.withOpacity(0.95),
                    primary.withOpacity(0.75),
                  ],
                ),
              ),
            ),
          ),
          ClipPath(
            clipper: _WaveClipper(offset: 24),
            child: Container(
              color: primary.withOpacity(0.20),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: const Alignment(0, -0.2),
              child: logo ?? const FlutterLogo(size: 72),
            ),
          ),
        ],
      ),
    );
  }
}

class _WaveClipper extends CustomClipper<Path> {
  final double offset;
  const _WaveClipper({this.offset = 0});

  @override
  Path getClip(Size size) {
    final width = size.width;
    final height = size.height;
    final path = Path();
    path.lineTo(0, height * 0.65 - offset);
    path.quadraticBezierTo(width * 0.25, height * 0.80 - offset, width * 0.5, height * 0.70 - offset);
    path.quadraticBezierTo(width * 0.75, height * 0.60 - offset, width, height * 0.75 - offset);
    path.lineTo(width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant _WaveClipper oldClipper) => oldClipper.offset != offset;
}