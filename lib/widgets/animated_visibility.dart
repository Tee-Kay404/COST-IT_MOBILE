import 'package:flutter/widgets.dart';

enum AnimationType {
  size,
  fade,
  slide,
  scale,
  sizeAndFade,
  slideAndFade,
  scaleAndFade,
}

class AnimatedVisibility extends StatefulWidget {
  final Duration duration;
  final bool visible;
  final Axis axis;
  final Widget child;
  final bool maintainState;
  final AnimationType animationType;
  final Curve curve;
  final Curve? reverseCurve;
  final Offset slideOffset;
  final double scaleBegin;
  final Widget? replacementChild;
  final void Function(AnimationController)? onControllerCreated;

  const AnimatedVisibility({
    super.key,
    this.duration = const Duration(milliseconds: 200),
    this.visible = false,
    this.axis = Axis.vertical,
    this.maintainState = true,
    this.animationType = AnimationType.size,
    this.curve = Curves.easeInOut,
    this.reverseCurve = Curves.easeInOut,
    this.slideOffset = const Offset(0.0, 0.2),
    this.scaleBegin = 0.8,
    this.onControllerCreated,
    this.replacementChild,
    required this.child,
  });

  @override
  State<AnimatedVisibility> createState() => _AnimatedVisibilityState();
}

class _AnimatedVisibilityState extends State<AnimatedVisibility>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
      reverseCurve: widget.reverseCurve,
    );

    if (widget.onControllerCreated != null) {
      widget.onControllerCreated!(_controller);
    }

    if (widget.visible) _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedVisibility oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.visible != oldWidget.visible) {
      if (widget.visible) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget current = widget.child;

    if (widget.animationType == AnimationType.fade ||
        widget.animationType == AnimationType.sizeAndFade ||
        widget.animationType == AnimationType.slideAndFade ||
        widget.animationType == AnimationType.scaleAndFade) {
      current = FadeTransition(
        opacity: _animation,
        child: current,
      );
    }

    if (widget.animationType == AnimationType.scale ||
        widget.animationType == AnimationType.scaleAndFade) {
      current = ScaleTransition(
        scale: Tween<double>(
          begin: widget.scaleBegin,
          end: 1.0,
        ).animate(_animation),
        child: current,
      );
    }

    if (widget.animationType == AnimationType.slide ||
        widget.animationType == AnimationType.slideAndFade) {
      current = SlideTransition(
        position: Tween<Offset>(
          begin: widget.slideOffset,
          end: Offset.zero,
        ).animate(_animation),
        child: current,
      );
    }

    if (widget.animationType == AnimationType.size ||
        widget.animationType == AnimationType.sizeAndFade) {
      final isVertical = (widget.axis == Axis.vertical);
      final isHorizontal = (widget.axis == Axis.horizontal);

      current = SizeTransition(
        axisAlignment: -1,
        sizeFactor: _animation,
        axis: widget.axis,
        child: SizedBox(
          height: isVertical ? null : null,
          width: isHorizontal ? null : null,
          child: current,
        ),
      );
    }

    return Visibility(
      maintainState: widget.maintainState,
      maintainSize: widget.maintainState,
      maintainAnimation: widget.maintainState,
      visible:
          widget.visible || _controller.status != AnimationStatus.dismissed,
      replacement: widget.replacementChild ?? SizedBox.shrink(),
      child: current,
    );
  }
}
