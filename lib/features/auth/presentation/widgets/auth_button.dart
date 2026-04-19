import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_textstyle.dart';

class AuthButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool isLoading;

  const AuthButton({
    super.key,
    required this.text,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        height: 55,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.primaryLight,
        ),
        child: Center(
          child: isLoading
              ? CircularProgressIndicator(color: AppColors.greyDisabled)
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      text,
                      style: AppTextStyles.bodyTextPrimary.copyWith(
                        color: AppColors.bgWhite,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(width: 10),
                    _buildArrowIcon(),
                  ],
                ),
        ),
      ),
    );
  }

  //---[Arrow Button]---
  Widget _buildArrowIcon() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.greyBorder),
      ),
      child: const Icon(
        Icons.arrow_forward,
        color: AppColors.bgWhite,
        size: 16,
      ),
    );
  }
}
