import 'package:flutter/foundation.dart' show immutable;

typedef CloseLoadingScreen = bool Function();

typedef UpdatedLoadingScreen = bool Function(String text);

@immutable
class LoadingScreenController {
  final CloseLoadingScreen close;
  final UpdatedLoadingScreen update;

  const LoadingScreenController({
    required this.close,
    required this.update,
  });
}
