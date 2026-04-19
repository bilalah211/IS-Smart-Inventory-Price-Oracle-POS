import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_textstyle.dart';
import '../utils/loader.dart';

class RoundedContainer extends StatelessWidget {
  final String name;
  final double? width;
  final double? height;
  final VoidCallback? onTap;
  final bool isLoading;

  const RoundedContainer({
    super.key,
    required this.name,
    this.onTap,
    this.isLoading = false,
    this.width = double.infinity,
    this.height = 55,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(10),
        ),
        child: isLoading
            ? MyLoader(color: Colors.white)
            : Center(
                child: Text(
                  name,
                  style: AppTextStyles.bodyTextPrimary.copyWith(
                    color: AppColors.bgWhite,
                    fontSize: 18,
                  ),
                ),
              ),
      ),
    );
  }
}
