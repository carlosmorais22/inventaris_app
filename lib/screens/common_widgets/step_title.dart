import 'package:flutter/material.dart';

class StepTitle extends StatelessWidget {
  final String title;
  final String subTitle;

  const StepTitle({super.key, this.title = "", this.subTitle = ""});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title.isNotEmpty
              ? Text(title,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).colorScheme.primary
                      ))
              : SizedBox(),
          subTitle.isEmpty
              ? SizedBox()
              : Text(subTitle,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      )),
          const SizedBox(
            height: 5.0,
          ),
        ],
      ),
    );
  }
}
