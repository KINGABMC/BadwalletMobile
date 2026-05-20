import 'package:flutter/material.dart';

// ── Couleurs exactes CampusNet ────────────────────────────────────────────────
class CampusColors {
  static const background = Color(0xFF0F1923);
  static const surface = Color(0xFF1A2535);
  static const surfaceLight = Color(0xFF1E2C3D);
  static const primary = Color(0xFF2D5BE3);
  static const teal = Color(0xFF2DD4BF);
  static const white = Color(0xFFFFFFFF);
  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFF8A9BB0);
  static const textLabel = Color(0xFFCDD5E0);
  static const border = Color(0xFF2A3A4E);
  static const error = Color(0xFFEF4444);
}

// ── Logo "CampusNet" ──────────────────────────────────────────────────────────
class CampusNetLogo extends StatelessWidget {
  final double fontSize;
  const CampusNetLogo({super.key, this.fontSize = 28});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'Campus',
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: CampusColors.teal,
            ),
          ),
          TextSpan(
            text: 'Net',
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: CampusColors.white,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Stepper 2 étapes ──────────────────────────────────────────────────────────
class CampusStepper extends StatelessWidget {
  final int currentStep;
  const CampusStepper({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(2, (index) {
        final isActive = index == currentStep;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 32 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive
                ? CampusColors.primary
                : CampusColors.textSecondary.withOpacity(0.4),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}

// ── Champ texte dark ──────────────────────────────────────────────────────────
class CampusTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData prefixIcon;
  final bool obscureText;
  final Widget? suffixWidget;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final TextInputAction textInputAction;

  const CampusTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.prefixIcon,
    this.obscureText = false,
    this.suffixWidget,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.textInputAction = TextInputAction.next,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                color: CampusColors.textLabel,
                fontSize: 14,
                fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          validator: validator,
          style: const TextStyle(fontSize: 15, color: CampusColors.textPrimary),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
                color: CampusColors.textSecondary, fontSize: 14),
            prefixIcon:
                Icon(prefixIcon, color: CampusColors.textSecondary, size: 18),
            suffixIcon: suffixWidget,
            filled: true,
            fillColor: CampusColors.surfaceLight,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: CampusColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: CampusColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: CampusColors.primary, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: CampusColors.error),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Dropdown dark ─────────────────────────────────────────────────────────────
class CampusDropdown extends StatelessWidget {
  final String label;
  final String hint;
  final String? value;
  final List<String> items;
  final void Function(String?) onChanged;

  const CampusDropdown({
    super.key,
    required this.label,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                color: CampusColors.textLabel,
                fontSize: 14,
                fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: value,
          dropdownColor: CampusColors.surface,
          style: const TextStyle(color: CampusColors.textPrimary, fontSize: 14),
          icon: const Icon(Icons.keyboard_arrow_down,
              color: CampusColors.textSecondary),
          hint: Text(hint,
              style: const TextStyle(
                  color: CampusColors.textSecondary, fontSize: 14)),
          decoration: InputDecoration(
            filled: true,
            fillColor: CampusColors.surfaceLight,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: CampusColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: CampusColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: CampusColors.primary, width: 1.5),
            ),
          ),
          items: items
              .map((item) => DropdownMenuItem(
                  value: item,
                  child: Text(item,
                      style: const TextStyle(
                          color: CampusColors.textPrimary, fontSize: 14))))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

// ── Bouton principal bleu + flèche ────────────────────────────────────────────
class CampusPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool showArrow;

  const CampusPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.showArrow = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: CampusColors.primary,
          foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                    strokeWidth: 2.5, color: Colors.white))
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(label,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                  if (showArrow) ...[
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward, size: 18),
                  ],
                ],
              ),
      ),
    );
  }
}

// ── Bouton Retour ─────────────────────────────────────────────────────────────
class CampusSecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const CampusSecondaryButton(
      {super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.arrow_back,
            size: 16, color: CampusColors.textPrimary),
        label: Text(label,
            style: const TextStyle(
                color: CampusColors.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w500)),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: CampusColors.border),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: CampusColors.surfaceLight,
        ),
      ),
    );
  }
}

// ── Bannière erreur ───────────────────────────────────────────────────────────
class ErrorBanner extends StatelessWidget {
  final String message;
  const ErrorBanner({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: CampusColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: CampusColors.error.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: CampusColors.error, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(message,
                style: const TextStyle(
                    color: CampusColors.error,
                    fontSize: 13,
                    fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}
