import 'package:flutter/material.dart';
import 'package:hypnosis_downloads/app/view/common/colors.dart';
import 'package:hypnosis_downloads/app/view/components/custom_loader_overlay.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CustomLoadingIndicator(),
    );
  }
}

class ErrorView extends StatelessWidget {
  const ErrorView(
    this.errorMessage, {
    Key? key,
  }) : super(key: key);

  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SelectableText(
        errorMessage,
        maxLines: 5,
        minLines: 1,
        style: const TextStyle(
          color: ComponentColors.errorTextColor,
        ),
      ),
    );
  }
}

class EmptyView extends StatelessWidget {
  const EmptyView(
    this.errorMessage, {
    Key? key,
  }) : super(key: key);

  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Text(
          errorMessage,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: ComponentColors.defaultTextColor,
          ),
        ),
      ),
    );
  }
}

get nothing => const SizedBox.shrink();

void showErrorMessage(BuildContext context, String errorMessage) {
  const longEnoughToReadText = Duration(seconds: 10);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(errorMessage),
      duration: longEnoughToReadText,
    ),
  );
}
