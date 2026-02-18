import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/responsive.dart';

/// Fausse status bar iPhone affichant heure, signal, wifi et batterie
class FakeStatusBar extends StatelessWidget {
  final bool isDark;

  const FakeStatusBar({super.key, this.isDark = false});

  @override
  Widget build(BuildContext context) {
    final color = isDark ? Colors.white : Colors.black;
    final now = TimeOfDay.now();
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');

    return Container(
      height: 44.h,
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Heure
          Text(
            '$hour:$minute',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),

          // Encoche (Dynamic Island simulée)
          Container(
            width: 90.w,
            height: 24.h,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(20.sp),
            ),
          ),

          // Icônes droites : signal + wifi + batterie
          Row(
            children: [
              // Signal (4 barres)
              _buildSignalIcon(color),
              SizedBox(width: 5.w),
              // Wifi
              Icon(Icons.wifi, size: 14.sp, color: color),
              SizedBox(width: 5.w),
              // Batterie
              _buildBatteryIcon(color),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSignalIcon(Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (int i = 0; i < 4; i++)
          Container(
            width: 3.w,
            height: (4 + i * 2.5).h,
            margin: EdgeInsets.only(right: 1.w),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(1.sp),
            ),
          ),
      ],
    );
  }

  Widget _buildBatteryIcon(Color color) {
    return Row(
      children: [
        Container(
          width: 22.w,
          height: 10.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2.sp),
            border: Border.all(color: color, width: 1),
          ),
          child: Padding(
            padding: EdgeInsets.all(1.5.w),
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(1.sp),
              ),
            ),
          ),
        ),
        Container(
          width: 1.5.w,
          height: 4.h,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(1.sp),
              bottomRight: Radius.circular(1.sp),
            ),
          ),
        ),
      ],
    );
  }
}
