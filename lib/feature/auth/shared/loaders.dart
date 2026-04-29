import 'dart:developer';
import 'package:cost_it_mobile/app/global/errors/error_handler.dart';
import 'package:cost_it_mobile/widgets/progress_loaders.dart';
import 'package:flutter/material.dart';

Future<T?> futureProgressCaller<T>(
  BuildContext context, {
  String loadingMessage = 'Loading...',
  LoaderType loaderType = LoaderType.popup,
  required Future<T> Function() computation,
  Function(Object)? onError,
}) async {
  T? result;
  switch (loaderType) {
    case LoaderType.popup:
      Loaders.showModalLoading(context, message: loadingMessage);
      break;
    case LoaderType.snack:
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      Loaders.showSnackLoading(context, message: loadingMessage);
      break;
    case LoaderType.sheet:
      Loaders.showSheetLoading(context, message: loadingMessage);
      break;
    case LoaderType.none:
      break;
  }
  try {
    result = await computation();
  } catch (error, stack) {
    log('error: $error, $stack');
    if (onError != null) {
      onError(error);
    } else {
      ErrorHandler.handle(context, error);
    }
  } finally {
    if (context.mounted) {
      switch (loaderType) {
        case LoaderType.popup:
          Navigator.of(context, rootNavigator: true).pop();
          break;
        case LoaderType.snack:
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          break;
        case LoaderType.sheet:
          Navigator.of(context, rootNavigator: true).pop();
          break;
        case LoaderType.none:
          break;
      }
    }
  }
  return result;
}
