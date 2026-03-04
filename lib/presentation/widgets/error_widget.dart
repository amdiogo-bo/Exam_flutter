import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';

class AppErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  const AppErrorWidget({super.key, required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          // Icône animée
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 700),
            curve: Curves.elasticOut,
            builder: (_, v, child) => Transform.scale(scale: v, child: child),
            child: Container(
              width: 100, height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.aurora5.withValues(alpha: 0.12),
                border: Border.all(
                  color: AppColors.aurora5.withValues(alpha: 0.4), width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.aurora5.withValues(alpha: 0.25),
                    blurRadius: 30, spreadRadius: 5,
                  ),
                ],
              ),
              child: const Center(
                child: Text('⚡', style: TextStyle(fontSize: 44)),
              ),
            ),
          ),
          const SizedBox(height: 28),

          Text(
            message,
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 18, fontWeight: FontWeight.w700,
              color: AppColors.aurora5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Vérifiez votre connexion et réessayez.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: Colors.white.withValues(alpha: 0.5),
            ),
          ),

          if (onRetry != null) ...[
            const SizedBox(height: 32),
            GestureDetector(
              onTap: onRetry,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  gradient: const LinearGradient(
                    colors: [AppColors.aurora5, AppColors.aurora4],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.aurora5.withValues(alpha: 0.4),
                      blurRadius: 20, spreadRadius: 1,
                    ),
                  ],
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.refresh_rounded,
                      color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'Réessayer',
                    style: GoogleFonts.outfit(
                      fontSize: 15, fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ]),
      ),
    );
  }
}
