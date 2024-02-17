import 'package:flutter/material.dart';
import 'package:ythumbnail/app/modules/home/controllers/home_controller.dart';

class DragTextWidget extends StatefulWidget {
  const DragTextWidget({
    super.key,
    required this.constraints,
    required this.controller,
  });

  final BoxConstraints constraints;
  final HomeController controller;

  @override
  State<DragTextWidget> createState() => _DragTextWidgetState();
}

class _DragTextWidgetState extends State<DragTextWidget> {
  late ValueNotifier<Offset> _offset;

  @override
  void initState() {
    _offset = ValueNotifier(const Offset(72 + 16, 120 + 32));
    super.initState();
  }

  @override
  void dispose() {
    _offset.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _offset,
      builder: (context, value, child) {
        return buildDraggablePosition();
      },
    );
  }

  Positioned buildDraggablePosition() {
    return Positioned(
      top: _offset.value.dy,
      left: _offset.value.dx,
      child: Draggable(
        feedback: buildText(),
        childWhenDragging: const SizedBox(),
        onDragEnd: onDrag,
        child: buildText(),
      ),
    );
  }

  void onDrag(DraggableDetails dragDetails) {
    final offset = Offset(
      dragDetails.offset.dx,
      dragDetails.offset.dy - kToolbarHeight - kBottomNavigationBarHeight,
    );
    _offset.value = offset;
  }

  SizedBox buildText() {
    return SizedBox(
      width: widget.constraints.maxWidth - 132 - 32,
      child: Text(
        widget.controller.baseTitle.value,
        style: Theme.of(context).textTheme.displayLarge!.copyWith(
              color: Colors.white,
            ),
      ),
    );
  }
}
