import 'package:flutter/material.dart';
import 'package:goexperts/core/app_constants/app_color.dart';

class AppGradientButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;

  const AppGradientButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  State<AppGradientButton> createState() => _AppGradientButtonState();
}

class _AppGradientButtonState extends State<AppGradientButton> {
  double _scale = 1.0;

  void _onTapDown(TapDownDetails details) {
    setState(() => _scale = 0.96);
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _scale = 1.0);
  }

  void _onTapCancel() {
    setState(() => _scale = 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _scale,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                AppColors.primaryColor,
                AppColors.secondaryColor,
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.indigo.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: GestureDetector(
            onTapDown: widget.isLoading ? null : _onTapDown,
            onTapUp: widget.isLoading ? null : _onTapUp,
            onTapCancel: widget.isLoading ? null : _onTapCancel,
            child: ElevatedButton(
              onPressed: widget.isLoading ? null : widget.onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: widget.isLoading
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        color: AppColors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      widget.text,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}