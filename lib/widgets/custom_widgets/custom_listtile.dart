import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final Widget leading;
  final Text title;
  final Text subTitle;
  final Function onTap;
  final Widget trailing;
  const CustomListTile(
      {super.key,
      required this.leading,
      required this.title,
      required this.subTitle,
      required this.onTap,
      required this.trailing});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: SizedBox(
        child: Row(children: [
          Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12.0),
            child: leading,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                title,
                const SizedBox(
                  height: 10,
                ),
                subTitle
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: trailing,
          )
        ]),
      ),
    );
  }
}
