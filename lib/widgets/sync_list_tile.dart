import 'package:flutter/material.dart';

class SyncListTile extends StatelessWidget {
  final Function? onTap;
  final Widget? titleWidget;
  final Widget? trailing;
  final Widget? leading;
  final EdgeInsetsGeometry? padding;

  ///Use this only if the titleWidget is null
  final String? titleText;

  const SyncListTile({
    this.titleWidget,
    this.onTap,
    this.titleText,
    this.trailing,
    this.leading,
    this.padding,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: ListTile(
        title: titleWidget ?? Text(titleText ?? ''),
        onTap: onTap != null ? () async => await onTap!() : null,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        trailing: trailing,
        leading: leading,
      ),
    );
  }
}
