import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String btnText;
  final Icon? icon;
  final Color? bgColor;
  final TextStyle? textStyle;
  final VoidCallback? callback;
  final double width;
  final EdgeInsetsGeometry padding;

  const Button({
    Key? key,
    required this.btnText,
    this.icon,
    this.bgColor = Colors.red,
    this.textStyle,
    this.callback,
    this.width = 200,
    required this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: () {
          callback?.call(); // Use callback?.call() for safer invocation
        },
        child: icon != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [icon!, Text(btnText, style: textStyle)],
              )
            : Text(btnText, style: textStyle),
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          shadowColor: bgColor,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7),
          ),
        ),
      ),
    );
  }
}
