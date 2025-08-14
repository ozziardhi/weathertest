import 'package:flutter/material.dart';

class GlassField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final bool obscure;
  final VoidCallback? onToggleObscure;
  final void Function(String)? onSubmitted;

  const GlassField({
    super.key,
    required this.label,
    required this.controller,
    required this.icon,
    this.validator,
    this.textInputAction,
    this.obscure = false,
    this.onToggleObscure,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      obscureText: obscure,
      validator: validator,
      textInputAction: textInputAction,
      onFieldSubmitted: onSubmitted,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(.08),
        prefixIcon: Icon(icon, color: Colors.white70),
        suffixIcon:
            onToggleObscure == null
                ? null
                : IconButton(
                  onPressed: onToggleObscure,
                  icon: Icon(
                    obscure ? Icons.visibility : Icons.visibility_off,
                    color: Colors.white70,
                  ),
                ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withOpacity(.35)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.white),
        ),
      ),
    );
  }
}
