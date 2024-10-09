import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:inventaris/utils/constants.dart';

class AppAlert {
  static Future<dynamic> success(
      {required String title,
      required String text,
      required BuildContext context,
      VoidCallback? onConfirmBtnTap}) {
    return CoolAlert.show(
      context: context,
      type: CoolAlertType.success,
      backgroundColor: Colors.greenAccent,
      title: title,
      text: text,
      titleTextStyle: Theme.of(context).textTheme.displayLarge!.copyWith(
          color: Theme.of(context).colorScheme.error,
          fontWeight: FontWeight.w600),
      textTextStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w600),
      confirmBtnColor: Theme.of(context).colorScheme.primary,
      confirmBtnTextStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
          color: Theme.of(context).colorScheme.inversePrimary,
          fontWeight: FontWeight.w600),
      cancelBtnTextStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
          color: Theme.of(context).colorScheme.inversePrimary,
          fontWeight: FontWeight.w600),
      confirmBtnText: kOk,
      onConfirmBtnTap: onConfirmBtnTap ?? () {},
    );
  }

  static Future<dynamic> debug(
      {required String title,
      required String text,
      required BuildContext context}) {
    return CoolAlert.show(
      context: context,
      type: CoolAlertType.warning,
      backgroundColor: Colors.deepOrangeAccent,
      title: title,
      text: text,
      confirmBtnText: kSim,
      confirmBtnColor: Theme.of(context).colorScheme.primary,
      confirmBtnTextStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
          color: Theme.of(context).colorScheme.inversePrimary,
          fontWeight: FontWeight.w600,
          fontSize: 18.0),
      cancelBtnText: kNao,
      cancelBtnTextStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
          color: Theme.of(context).colorScheme.inversePrimary,
          fontWeight: FontWeight.w600,
          fontSize: 18.0),
    );
  }

  static Future<dynamic> info(
      {required String title,
      required String text,
      required BuildContext context,
      VoidCallback? onConfirmBtnTap}) {
    return CoolAlert.show(
      context: context,
      type: CoolAlertType.info,
      backgroundColor: Colors.blue.shade50,
      title: title,
      text: text,
      confirmBtnText: kOk,
      // onConfirmBtnTap: () {
      //   Navigator.pop(context);
      // },
      titleTextStyle: Theme.of(context).textTheme.displayLarge!.copyWith(
          color: Theme.of(context).colorScheme.inversePrimary,
          fontWeight: FontWeight.w600),
      textTextStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w600),
      confirmBtnColor: Theme.of(context).colorScheme.primary,
      confirmBtnTextStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
          color: Theme.of(context).colorScheme.inversePrimary,
          fontWeight: FontWeight.w600),
      onConfirmBtnTap: onConfirmBtnTap ?? () {},
    );
  }

  static Future<dynamic> confirm(
      {required String title,
      required String text,
      required BuildContext context,
      required VoidCallback? onConfirmBtnTap}) {
    return CoolAlert.show(
      context: context,
      type: CoolAlertType.confirm,
      backgroundColor: Colors.blue.shade50,
      title: title,
      text: text,
      titleTextStyle: Theme.of(context).textTheme.displayLarge!.copyWith(
          color: Theme.of(context).colorScheme.error,
          fontWeight: FontWeight.w600),
      textTextStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w600),
      confirmBtnColor: Theme.of(context).colorScheme.primary,
      confirmBtnTextStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
          color: Theme.of(context).colorScheme.inversePrimary,
          fontWeight: FontWeight.w600),
      cancelBtnTextStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
          color: Theme.of(context).colorScheme.inversePrimary,
          fontWeight: FontWeight.w600),
      confirmBtnText: kSim,
      cancelBtnText: kNao,
      onConfirmBtnTap: onConfirmBtnTap,
    );
  }

  static Future<dynamic> error(
      {String title = kError,
      required String text,
      required BuildContext context}) {
    return CoolAlert.show(
      context: context,
      type: CoolAlertType.error,
      backgroundColor: Colors.redAccent,
      title: title,
      text: text,
      confirmBtnText: kOk,
      confirmBtnColor: Theme.of(context).colorScheme.primary,
      confirmBtnTextStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
          color: Theme.of(context).colorScheme.inversePrimary,
          fontWeight: FontWeight.w600,
          fontSize: 18.0),
    );
  }
}
