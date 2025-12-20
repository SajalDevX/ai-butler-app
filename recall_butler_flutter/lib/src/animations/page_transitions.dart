import 'package:flutter/material.dart';

/// Custom page route with slide transition
class SlidePageRoute extends PageRouteBuilder {
  final Widget page;
  final AxisDirection direction;

  SlidePageRoute({
    required this.page,
    this.direction = AxisDirection.left,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: const Duration(milliseconds: 300),
          reverseTransitionDuration: const Duration(milliseconds: 250),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            Offset begin;
            switch (direction) {
              case AxisDirection.up:
                begin = const Offset(0, 1);
                break;
              case AxisDirection.down:
                begin = const Offset(0, -1);
                break;
              case AxisDirection.left:
                begin = const Offset(1, 0);
                break;
              case AxisDirection.right:
                begin = const Offset(-1, 0);
                break;
            }

            const end = Offset.zero;
            final tween = Tween(begin: begin, end: end);
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
              reverseCurve: Curves.easeInCubic,
            );

            return SlideTransition(
              position: tween.animate(curvedAnimation),
              child: child,
            );
          },
        );
}

/// Custom page route with fade + scale transition
class FadeScalePageRoute extends PageRouteBuilder {
  final Widget page;

  FadeScalePageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: const Duration(milliseconds: 300),
          reverseTransitionDuration: const Duration(milliseconds: 250),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
              reverseCurve: Curves.easeInCubic,
            );

            return FadeTransition(
              opacity: curvedAnimation,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.92, end: 1.0).animate(curvedAnimation),
                child: child,
              ),
            );
          },
        );
}

/// Custom page route with rotation + fade transition
class RotationPageRoute extends PageRouteBuilder {
  final Widget page;

  RotationPageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: const Duration(milliseconds: 400),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
              reverseCurve: Curves.easeInCubic,
            );

            return RotationTransition(
              turns: Tween<double>(begin: 0.05, end: 0.0).animate(curvedAnimation),
              child: FadeTransition(
                opacity: curvedAnimation,
                child: child,
              ),
            );
          },
        );
}

/// Custom page route with shared axis transition (Material 3 style)
class SharedAxisPageRoute extends PageRouteBuilder {
  final Widget page;
  final SharedAxisTransitionType transitionType;

  SharedAxisPageRoute({
    required this.page,
    this.transitionType = SharedAxisTransitionType.scaled,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: const Duration(milliseconds: 300),
          reverseTransitionDuration: const Duration(milliseconds: 250),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
              reverseCurve: Curves.easeInCubic,
            );

            switch (transitionType) {
              case SharedAxisTransitionType.horizontal:
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.3, 0.0),
                    end: Offset.zero,
                  ).animate(curvedAnimation),
                  child: FadeTransition(
                    opacity: curvedAnimation,
                    child: child,
                  ),
                );

              case SharedAxisTransitionType.vertical:
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.0, 0.3),
                    end: Offset.zero,
                  ).animate(curvedAnimation),
                  child: FadeTransition(
                    opacity: curvedAnimation,
                    child: child,
                  ),
                );

              case SharedAxisTransitionType.scaled:
                return ScaleTransition(
                  scale: Tween<double>(begin: 0.8, end: 1.0).animate(curvedAnimation),
                  child: FadeTransition(
                    opacity: curvedAnimation,
                    child: child,
                  ),
                );
            }
          },
        );
}

enum SharedAxisTransitionType {
  horizontal,
  vertical,
  scaled,
}

/// Extension on Navigator for easy transitions
extension NavigatorTransitions on BuildContext {
  Future<T?> pushWithSlide<T>(Widget page, {AxisDirection direction = AxisDirection.left}) {
    return Navigator.of(this).push<T>(SlidePageRoute(page: page, direction: direction));
  }

  Future<T?> pushWithFadeScale<T>(Widget page) {
    return Navigator.of(this).push<T>(FadeScalePageRoute(page: page));
  }

  Future<T?> pushWithRotation<T>(Widget page) {
    return Navigator.of(this).push<T>(RotationPageRoute(page: page));
  }

  Future<T?> pushWithSharedAxis<T>(
    Widget page, {
    SharedAxisTransitionType type = SharedAxisTransitionType.scaled,
  }) {
    return Navigator.of(this).push<T>(
      SharedAxisPageRoute(page: page, transitionType: type),
    );
  }
}
