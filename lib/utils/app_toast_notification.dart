import 'package:flutter/material.dart';
import 'package:inventaris/utils/constants.dart';
import 'package:toastification/toastification.dart';

class AppToastNotification {
  static void success(
      {String? title,
      required String text,
      required BuildContext context,
      VoidCallback? onConfirmBtnTap}) {
    toastification.show(
      context: context, // optional if you use ToastificationWrapper
      type: ToastificationType.success,
      style: ToastificationStyle.flatColored,
      autoCloseDuration: const Duration(seconds: 4),
      title: Text(title != null ? title! : kSucesso),
      description: Text(text),
      icon: const Icon(Icons.check),
      showIcon: true, // show or hide the icon
      showProgressBar: true,
      animationDuration: const Duration(milliseconds: 300),
      pauseOnHover: true,
    );
  }

  static void error(
      {String? title,
      required String text,
      required BuildContext context,
      VoidCallback? onConfirmBtnTap}) {
    toastification.show(
      context: context, // optional if you use ToastificationWrapper
      type: ToastificationType.error,
      style: ToastificationStyle.flatColored,
      autoCloseDuration: const Duration(seconds: 5),
      title: Text(title != null ? title! : kSucesso),
      description: Text(text),
      icon: const Icon(Icons.error),
      showIcon: true, // show or hide the icon
      showProgressBar: true,
      animationDuration: const Duration(milliseconds: 300),
      pauseOnHover: true,
    );
  }
}
