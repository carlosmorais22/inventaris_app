import 'package:flutter/material.dart';

class CustonElevatedButton extends StatelessWidget {
  late String text;
  late VoidCallback? onClickBtnTap;

  CustonElevatedButton(
      {super.key, required this.text, required this.onClickBtnTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minWidth: 120),
      height: 40,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: onClickBtnTap,
        child: Text(
          text,
          style: Theme.of(context).textTheme.displayMedium!.copyWith(
              color: onClickBtnTap == null
                  ? Theme.of(context).colorScheme.tertiary
                  : Theme.of(context).colorScheme.surface,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
