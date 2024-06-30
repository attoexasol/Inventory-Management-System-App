import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final bool secureText;
  final InputDecoration decoration;
  final TextInputType keyboardtype;
  final Icon? icon;

  const InputField({
    Key? key,
    required this.controller,
    this.secureText = false,
    this.icon,
    required this.decoration,
    this.keyboardtype = TextInputType.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return icon != null
        ? Container(
            decoration: BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: Colors.grey, width: 1.0))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: TextField(
                    key: key, // Pass down the key if needed
                    controller: controller,
                    keyboardType: keyboardtype,
                    decoration: decoration.copyWith(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 16),
                        border:
                            OutlineInputBorder(borderSide: BorderSide.none)),
                    obscureText: secureText,
                  ),
                ),
                icon!,
              ],
            ),
          )
        : TextField(
            key: key,
            controller: controller,
            keyboardType: keyboardtype,
            decoration: decoration,
            obscureText: secureText,
          );
  }
}
