import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'colors.dart';

class Text_Field extends StatelessWidget {
  var controller, label, hintText, type, suffixIcon;
  double horizonatlPadding, verticalPadding;
  bool obSecure;
  Text_Field(
      {super.key,
        required this.controller,
        required this.label,
        required this.hintText,
        this.horizonatlPadding = 28,
        this.verticalPadding = 8,
        this.type = TextInputType.text,
        this.suffixIcon,
        this.obSecure = false});
  @override
  Widget build(BuildContext context) {
      return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: horizonatlPadding, vertical: verticalPadding),
        child: SizedBox(
          height: 70,
          child: TextFormField(
            cursorColor: Colors.lightBlue,
            keyboardType: type,
            controller: controller,
            decoration: InputDecoration(
                contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                helperText: ' ',
                hintStyle: TextStyle(fontFamily: 'sans', color: primary),
                labelText: label,
                labelStyle:
                const TextStyle(color: Colors.black54, fontFamily: 'sans'),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black54),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryDark),
                  borderRadius: BorderRadius.circular(5),
                ),
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.lightBlue))),
            validator: (value) {
              if (value!.isEmpty) {
                return hintText;
              }
              return null;
            },
          ),
        ),
      );
  }
}