import 'package:flutter/material.dart';

enum ButtonType { number, operator, function, equal }

class CalcButton {
  final String label;
  final ButtonType type;
  final VoidCallback onTap;
  const CalcButton({
    required this.label,
    required this.onTap,
    this.type = ButtonType.number,
  });
}

class CalculateButton extends StatelessWidget {
  final String label;
  final ButtonType type;
  final VoidCallback onTap;

  const CalculateButton({
    required this.label,
    required this.type,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isOperator = type == ButtonType.operator || type == ButtonType.equal;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final Color bg = type == ButtonType.equal
        ? scheme.primary
        : (isOperator
              ? scheme.primaryContainer
              : scheme.surfaceContainerHighest);
    final Color fg = type == ButtonType.equal
        ? scheme.onPrimary
        : (isOperator ? scheme.onPrimaryContainer : scheme.onSurfaceVariant);

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: bg,
        foregroundColor: fg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(vertical: 18),
        textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
      ),
      onPressed: onTap,
      child: Text(label),
    );
  }
}
