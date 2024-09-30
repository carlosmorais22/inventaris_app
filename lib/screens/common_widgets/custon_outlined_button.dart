import 'package:flutter/material.dart';

class CustonOutlinedButton extends StatelessWidget {
  late String text;
  late VoidCallback? onClickBtnTap;

  CustonOutlinedButton(
      {super.key, required this.text, required this.onClickBtnTap});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.onBackground,
        side: BorderSide(
          color: Theme.of(context).colorScheme.primary,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: onClickBtnTap,
      child: Text(text),
    );
  }
}
