import 'package:flutter/material.dart';
import 'dart:html' as html;

extension HuddleLinkText on Text {
  Widget createGradientLink(
      {Gradient gradient = const LinearGradient(
          colors: [Colors.deepPurple, Colors.deepOrange, Colors.pink])}) {
    return ShaderMask(
        shaderCallback: (bounds) {
          return gradient.createShader(Offset.zero & bounds.size);
        },
        child: this);
  }
}

extension HoverExtension on Widget {
  static final appContainer =
      html.window.document.getElementById('app-container');
  Widget get showCursorOnHover {
    return MouseRegion(
      child: this,
      onHover: (e) {
        appContainer.style.cursor = 'pointer';
      },
      onExit: (e) {
        appContainer.style.cursor = 'default';
      },
    );
  }

  Widget get moveUpOnHover => Hoverable(child: this);

  Widget translateOnHover(TranslationType type, int translationFactor) =>
      HoverTranslatated(this, type: type, translationFactor: translationFactor);
}

class Hoverable extends StatefulWidget {
  final Widget child;
  final Color hoverColor, backgroundColor;
  Hoverable(
      {Key key,
      this.child,
      this.hoverColor = const Color(0xFF57D131),
      this.backgroundColor = Colors.transparent})
      : super(key: key);
  @override
  _HoverableState createState() => _HoverableState();
}

class _HoverableState extends State<Hoverable> {
  final nonHoverTransform = Matrix4.identity()..translate(0, 0);
  final hoverTransform = Matrix4.identity()..translate(0, -5);
  bool _isHovering = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
        onExit: (e) {
          setState(() {
            _isHovering = false;
          });
        },
        onEnter: (e) {
          setState(() {
            _isHovering = true;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          color: _isHovering ? widget.hoverColor : widget.backgroundColor,
          transform: _isHovering ? hoverTransform : nonHoverTransform,
          child: widget.child,
        ));
  }
}

class HoverTranslatated extends StatefulWidget {
  final Widget child;
  final TranslationType type;
  final int translationFactor;

  const HoverTranslatated(this.child, {this.type, this.translationFactor = 20});

  @override
  _HoverTranslatatedState createState() => _HoverTranslatatedState();
}

class _HoverTranslatatedState extends State<HoverTranslatated> {
  final nonHoverTransform = Matrix4.identity()..translate(0, 0);
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    int tx = 0, ty = 0;
    if (widget.type == TranslationType.BOTTOM_TO_TO) {
      ty = -widget.translationFactor;
    } else if (widget.type == TranslationType.TOP_TO_BOTTOM) {
      ty = widget.translationFactor;
    } else if (widget.type == TranslationType.LEFT_TO_RIGHT) {
      tx = -widget.translationFactor;
    } else {
      tx = widget.translationFactor;
    }
    final hoverTransform = Matrix4.identity()
      ..translate(tx.toDouble(), ty.toDouble())
      ..scale(1, 0.9, 1);
    return MouseRegion(
        onExit: (e) {
          setState(() {
            _isHovering = false;
          });
        },
        onEnter: (e) {
          setState(() {
            _isHovering = true;
          });
        },
        child: AnimatedContainer(
          curve: Curves.easeInOut,
          duration: const Duration(milliseconds: 200),
          color: Colors.transparent,
          transform: _isHovering ? hoverTransform : nonHoverTransform,
          child: widget.child,
        ));
  }
}

enum TranslationType {
  TOP_TO_BOTTOM,
  BOTTOM_TO_TO,
  LEFT_TO_RIGHT,
  RIGHT_TO_LEFT
}
