import 'dart:ui';
import 'package:flutter/material.dart';

Future<T?> showAppPopup<T>({
  required BuildContext context,
  required Widget Function(BuildContext) builder,
  bool barrierDismissible = true,
}) {
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.transparent,
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (ctx, anim, secondAnim) {
      final curved = CurvedAnimation(parent: anim, curve: Curves.easeOut);
      return _AppPopupOverlay(
        animation: curved,
        barrierDismissible: barrierDismissible,
        child: builder(ctx),
      );
    },
  );
}

class _AppPopupOverlay extends AnimatedWidget {
  final bool barrierDismissible;
  final Widget child;

  const _AppPopupOverlay({
    required Animation<double> animation,
    required this.barrierDismissible,
    required this.child,
  }) : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    final value = (listenable as Animation<double>).value;
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: barrierDismissible ? () => Navigator.of(context).pop() : null,
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 8 * value,
                sigmaY: 8 * value,
              ),
              child: Container(
                color: Color.fromRGBO(0, 0, 0, 0.54 * value),
              ),
            ),
          ),
        ),
        AnimatedPadding(
          duration: const Duration(milliseconds: 100),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom / 2,
          ),
          child: Center(
            child: Opacity(
              opacity: value,
              child: Transform.scale(
                scale: 0.9 + 0.1 * value,
                child: child,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
