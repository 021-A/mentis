// lib/widgets/password_field.dart
import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData? prefixIcon;
  final String? Function(String?)? validator;
  final bool enabled;

  const PasswordField({
    super.key,
    required this.controller,
    required this.labelText,
    this.prefixIcon,
    this.validator,
    this.enabled = true,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _isObscured,
      enabled: widget.enabled,
      decoration: InputDecoration(
        prefixIcon: Icon(widget.prefixIcon ?? Icons.lock_outline),
        labelText: widget.labelText,
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _isObscured = !_isObscured;
            });
          },
          icon: Icon(
            _isObscured ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey.shade600,
          ),
        ),
      ),
      validator: widget.validator,
    );
  }
}