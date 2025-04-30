import 'dart:async';
import 'package:flutter/material.dart';

/// A widget that delays the rebuild of its child widget until the specified delay has passed.
/// If the child widget is the same, it wont rebuild.
/// To acomplish this, the child widget must have a key assigned to compare it with the older child widget.
class DelayedRebuildWidget extends StatefulWidget {
  final Widget child;
  final Duration delay;

  DelayedRebuildWidget({
    super.key,
    required this.child,
    this.delay = const Duration(milliseconds: 500),
  }) : assert(child.key != null, 'Child widget must have a key to be compared');

  @override
  State<DelayedRebuildWidget> createState() => _DelayedRebuildWidgetState();
}

class _DelayedRebuildWidgetState extends State<DelayedRebuildWidget> {
  late Widget _currentChild;
  Timer? _rebuildTimer;

  @override
  void initState() {
    super.initState();
    _currentChild = widget.child;
  }

  @override
  void didUpdateWidget(covariant DelayedRebuildWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.child.key != widget.child.key) {
      _rebuildTimer?.cancel();
      _rebuildTimer = Timer(widget.delay, () {
        _currentChild = widget.child;
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    _rebuildTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _currentChild;
  }
}
