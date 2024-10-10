import 'package:flutter/material.dart';

class CustonOutlinedButton extends StatelessWidget {
  late String text;
  late VoidCallback? onClickBtnTap;

  CustonOutlinedButton(
      {super.key, required this.text, required this.onClickBtnTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      constraints: BoxConstraints(minWidth: 120),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.surface,
          side: BorderSide(
            color: Theme.of(context).colorScheme.primary,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: onClickBtnTap,
        child: Text(text),
      ),
    );
  }
}
