import 'package:flutter/material.dart';
import 'package:smartinevntary/core/theme/app_colors.dart';

class MyTextFormField extends StatelessWidget {
  final String text;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final bool isObscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;

  const MyTextFormField({
    super.key,
    required this.text,
    this.validator,
    this.controller,
    this.isObscureText = false,
    this.suffixIcon,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isObscureText,
      decoration: InputDecoration(
        hintText: text,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.primary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.red),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade500),
        ),
      ),
      validator: validator,
    );
  }
}
