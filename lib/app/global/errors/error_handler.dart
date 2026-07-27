import 'dart:developer';

import 'package:cost_it_mobile/app/global/dialog/app_message_dialog.dart';
import 'package:cost_it_mobile/app/global/dialog/scaffold_message.dart';
import 'package:cost_it_mobile/app/global/utils/exception.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ErrorHandler {
  ErrorHandler._();

  static void handle(
    BuildContext context,
    dynamic error, {
    Map<String, void Function(String)>? fieldErrors,
  }) {
    // Unwrap GlobalException from DioException.error
    final appException = _unwrap(error);

    if (appException != null) {
      final handled = _handleFieldErrors(appException, fieldErrors);
      if (!handled) {
        // Only show generic dialog if no field errors were populated
        _showExceptionMessage(context, appException);
      }
      return;
    }

    // Fallback for non-Dio errors (e.g., local exceptions)

    log('Untyped error: $error');
    showErrorExceptionToast(context, 'Something went wrong, please try again');
  }

  static GlobalException? _unwrap(dynamic error) {
    if (error is GlobalException) return error;
    if (error is DioException && error.error is GlobalException) {
      return error.error as GlobalException;
    }
    return null;
  }

  // field errors still delegate to serverErrorHandler's field logic
  static bool _handleFieldErrors(
    GlobalException ex,
    Map<String, void Function(String)>? fieldErrors,
  ) {
    log(
      '_handleFieldErrors — raw: ${ex.raw}, fieldErrors keys: ${fieldErrors?.keys}',
    );

    if (fieldErrors == null || ex.raw == null) return false;

    bool anyHandled = false;
    try {
      if (ex.raw is Map<String, dynamic>) {
        final errors = ex.raw['errors'];
        if (errors is Map<String, dynamic>) {
          errors.forEach((field, message) {
            if (fieldErrors.containsKey(field)) {
              fieldErrors[field]?.call(message.toString());
              anyHandled = true;
            }
          });
        }
      }
    } catch (e) {
      log('Field parsing failed: $e');
    }
    return anyHandled;
  }

  static void _showExceptionMessage(BuildContext context, GlobalException ex) {
    switch (ex.type) {
      case ErrorType.badRequest:
        showErrorExceptionToast(
          context,
          'Something went wrong with your request!',
        );
        break;
      case ErrorType.notFound:
        ScaffoldMessenger.of(context).showSnackBar(
          ScaffoldMessage(
            message: 'Request source not found!',
            context: context,
          ),
        );
        break;

      case ErrorType.unauthorized:
        showAppMessageDialog(
          context,
          "Unauthorized",
          Icons.lock,
          "Session expired!, please login again.",
          "Login",
        );
        break;

      case ErrorType.noInternet:
        showAppMessageDialog(
          context,
          "No Internet!",
          Icons.wifi_off,
          "Please check your connection.",
          "Try again",
        );
        break;

      case ErrorType.timeout:
        showAppMessageDialog(
          context,
          "Timeout",
          Icons.timer_off,
          "Connection timed out!, try again.",
          "Retry",
        );
        break;
      case ErrorType.forbidden:
        showAppMessageDialog(
          context,
          "Sorry",
          Icons.cancel_outlined,
          "You don't have permission to do this!",
          "Retry",
        );
        break;
      case ErrorType.serverError:
        showErrorExceptionToast(context, 'Internal server error!, try again.');
        break;
      case ErrorType.conflict:
        showErrorExceptionToast(
          context,
          'A conflict occured, please try again!',
        );
        break;

      default:
        showErrorExceptionToast(context, 'Something went wrong!, try again');
    }
  }

  // static void _handleFieldErrors(
  //   GlobalException ex,
  //   Map<String, void Function(String)>? fieldErrors,
  // ) {
  //   if (fieldErrors == null || ex.raw == null) return;

  //   try {
  //     if (ex.raw is Map<String, dynamic>) {
  //       final errors = ex.raw['errors'];

  //       if (errors is Map<String, dynamic>) {
  //         errors.forEach((field, message) {
  //           if (fieldErrors.containsKey(field)) {
  //             fieldErrors[field]?.call(message.toString());
  //           }
  //         });
  //       }
  //     }
  //   } catch (e) {
  //     log('Field parsing failed: $e');
  //   }
  // }
}


//  static void handle(
//     BuildContext context,
//     dynamic error, {
  //   Map<String, void Function(String)>? fieldErrors,
  // }) {
  //   final appException = _unwrap(error);

  //   if (appException != null) {
  //     _handleFieldErrors(appException, fieldErrors);
  //     _showExceptionMessage(context, appException);
  //     return;
  //   }

  //   log('Untyped error: $error');
  //   showErrorExceptionToast(context, 'Something went wrong, please try again');
  // }

  // static GlobalException? _unwrap(dynamic error) {
  //   if (error is GlobalException) return error;
  //   if (error is DioException && error.error is GlobalException) {
  //     return error.error as GlobalException;
  //   }
  //   return null;
  // }
