import 'package:flutter/material.dart';
import 'package:cool_alert/cool_alert.dart';

class MyAlert {

  static Future<dynamic> success({required String title, required String text, required BuildContext context, VoidCallback? onConfirmBtnTap}) {
    return CoolAlert.show(
      context: context,
      type: CoolAlertType.success,
      backgroundColor: Colors.greenAccent,

      title: title,
      text: text,

      confirmBtnText: 'Ok',
      confirmBtnColor: Theme.of(context).colorScheme.inversePrimary,
      confirmBtnTextStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
        color: Theme.of(context).colorScheme.primary,
      ),
      onConfirmBtnTap: onConfirmBtnTap ?? () {},
    );
  }

  static Future<dynamic> debug({required String title, required String text, required BuildContext context}) {
    return CoolAlert.show(
      context: context,
      type: CoolAlertType.warning,
      backgroundColor: Colors.deepOrangeAccent,

      title: title,
      text: text,

      confirmBtnText: 'Sim',
      confirmBtnColor: Theme.of(context).colorScheme.primary,
      confirmBtnTextStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
          color: Theme.of(context).colorScheme.inversePrimary,
          fontWeight:FontWeight.w600,
          fontSize: 18.0
      ),
      cancelBtnText: 'Não',
      cancelBtnTextStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
          color: Theme.of(context).colorScheme.inversePrimary,
          fontWeight:FontWeight.w600,
          fontSize: 18.0
      ),
    );
  }

  static Future<dynamic> info({required String title, required String text, required BuildContext context}) {
    return CoolAlert.show(
      context: context,
      type: CoolAlertType.info,
      backgroundColor: Colors.blue.shade50,

      title: title,
      text: text,

      confirmBtnText: 'Ok',
      confirmBtnColor: Theme.of(context).colorScheme.primary,
      confirmBtnTextStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
          color: Theme.of(context).colorScheme.inversePrimary,
          fontWeight:FontWeight.w600,
          fontSize: 18.0
      ),
    );
  }

  static Future<dynamic> confirm({required String title, required String text, required BuildContext context, required VoidCallback? onConfirmBtnTap}) {
    return CoolAlert.show(
      context: context,
      type: CoolAlertType.confirm,
      backgroundColor: Colors.blue.shade50,

      title: title,
      text: text,

      confirmBtnText: 'Sim',
      confirmBtnColor: Theme.of(context).colorScheme.primary,
      confirmBtnTextStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
          color: Theme.of(context).colorScheme.inversePrimary,
          fontWeight:FontWeight.w600,
          fontSize: 18.0
      ),
      cancelBtnText: 'Não',
      cancelBtnTextStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
          color: Theme.of(context).colorScheme.inversePrimary,
          fontWeight:FontWeight.w600,
          fontSize: 18.0
      ),
      onConfirmBtnTap: onConfirmBtnTap,
    );
  }

  static Future<dynamic> error({String title = "Error!!!", required String text, required BuildContext context}) {
    return CoolAlert.show(
      context: context,
      type: CoolAlertType.error,
      backgroundColor: Colors.redAccent,

      title: title,
      text: text,

      confirmBtnText: 'ok',
      confirmBtnColor: Theme.of(context).colorScheme.primary,
      confirmBtnTextStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
          color: Theme.of(context).colorScheme.inversePrimary,
          fontWeight:FontWeight.w600,
          fontSize: 18.0
      ),
    );
  }
}