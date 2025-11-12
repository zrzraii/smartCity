import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const primary = Color(0xFF6337EF);
  static const bg = Color(0xFFF9F9F9);
  static const surface = Colors.white;
  static const textPrimary = Color(0xFF1E2022);
  static const textSecondary = Color(0xFF77838F);
}

class Gaps {
  static const s = SizedBox(height: 8, width: 8);
  static const m = SizedBox(height: 12, width: 12);
  static const l = SizedBox(height: 16, width: 16);
}

ThemeData buildAppTheme() {
  final base = ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary));
  final text = GoogleFonts.poppinsTextTheme(base.textTheme).apply(
    bodyColor: AppColors.textPrimary,
    displayColor: AppColors.textPrimary,
  );
  return base.copyWith(
    scaffoldBackgroundColor: AppColors.bg,
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.transparent,
      centerTitle: true,
      foregroundColor: AppColors.textPrimary,
    ),
    textTheme: text,
  );
}

class SectionTitle extends StatelessWidget {
  final String text;
  const SectionTitle(this.text, {super.key});
  @override
  Widget build(BuildContext context) => Text(text, style: Theme.of(context).textTheme.titleMedium);
}

class SquareIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const SquareIconButton({super.key, required this.icon, this.onTap});
  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: SizedBox(width: 40, height: 40, child: Icon(icon, color: AppColors.textPrimary)),
      ),
    );
  }
}

class CardContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  const CardContainer({super.key, required this.child, this.padding = const EdgeInsets.all(12)});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(8)),
      padding: padding,
      child: child,
    );
  }
}
