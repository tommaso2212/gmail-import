import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

sealed class _Status {}

class _Loading implements _Status {}

class _Progress implements _Status {
  _Progress(this.percentage);

  final double percentage;
}

class _Error implements _Status {
  _Error(this.errorMessage);

  final String errorMessage;
}

final loaderManagerProvider = StateNotifierProvider<LoaderManager, _Status?>(
  (ref) => LoaderManager(),
);

class LoaderManager extends StateNotifier<_Status?> {
  LoaderManager() : super(null);

  static final _overlayController = OverlayPortalController();

  void reset() => state = null;

  void emitLoading() => state = _Loading();

  void emitProgress(double percentage) => state = _Progress(percentage);

  void emitError({
    String errorMessage = 'generic',
  }) =>
      state = _Error(errorMessage);
}

class LoaderManagerWrapper extends ConsumerWidget {
  const LoaderManagerWrapper({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      loaderManagerProvider,
      (previous, next) => switch (next) {
        null => LoaderManager._overlayController.hide(),
        _Loading() => LoaderManager._overlayController.show(),
        _Error() => LoaderManager._overlayController.show(),
        _Progress() => LoaderManager._overlayController.show(),
      },
    );
    return OverlayPortal(
      controller: LoaderManager._overlayController,
      overlayChildBuilder: (context) => ColoredBox(
        color: Colors.black.withAlpha(130),
        child: switch (ref.read(loaderManagerProvider)) {
          null => const SizedBox.shrink(),
          _Loading() => const Center(
              child: CircularProgressIndicator(
                semanticsLabel: 'Caricamento',
              ),
            ),
          _Error(:String errorMessage) => AlertDialog(
              title: Text('Error'),
              content: Text(errorMessage),
              actions: [
                FilledButton(
                  onPressed: () => LoaderManager._overlayController.hide(),
                  child: const Text('OK'),
                ),
              ],
            ),
          _Progress(:double percentage) => Center(
              child: CircularProgressIndicator(
                semanticsLabel: 'Caricamento',
                value: percentage,
              ),
            ),
        },
      ),
      child: child,
    );
  }
}
