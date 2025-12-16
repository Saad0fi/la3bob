import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:la3bob/core/comon/theme/app_color.dart';
import 'package:la3bob/core/constants/interests.dart';

class InterestsSelector extends StatefulWidget {
  final Set<String> selectedInterests;
  final ValueChanged<Set<String>> onChanged;

  const InterestsSelector({
    super.key,
    required this.selectedInterests,
    required this.onChanged,
  });

  @override
  State<InterestsSelector> createState() => _InterestsSelectorWidgetState();
}

class _InterestsSelectorWidgetState extends State<InterestsSelector> {
  late final Set<String> _localInterests;

  @override
  void initState() {
    super.initState();
    _localInterests = {...widget.selectedInterests};
  }

  void _toggleInterest(String interest, bool selected) {
    setState(() {
      if (selected) {
        _localInterests.add(interest);
      } else {
        _localInterests.remove(interest);
      }
    });
    widget.onChanged(_localInterests);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.interests, color: AppColors.accent, size: 5.w),
            SizedBox(width: 2.w),
            Text(
              'اهتمامات الطفل',
              style: TextStyle(
                fontSize: 13.dp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            if (_localInterests.isNotEmpty) ...[
              SizedBox(width: 2.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${_localInterests.length}',
                  style: TextStyle(fontSize: 9.dp, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ],
        ),
        SizedBox(height: 1.5.h),
        Card(
          elevation: 2,
          shadowColor: _localInterests.isEmpty ? Colors.red.withValues(alpha: .3) : Colors.grey.withValues(alpha: .2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: _localInterests.isEmpty ? Colors.red.shade300 : Colors.transparent,
              width: 1,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Wrap(
              spacing: 2.w,
              runSpacing: 1.5.h,
              textDirection: TextDirection.rtl,
              children: InterestsConstants.availableInterests.map((interest) {
                final isSelected = _localInterests.contains(interest);
                return FilterChip(
                  label: Text(interest),
                  selected: isSelected,
                  onSelected: (selected) => _toggleInterest(interest, selected),
                  selectedColor: AppColors.accent.withValues(alpha: .25),
                  backgroundColor: Colors.grey.shade100,
                  showCheckmark: false,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: isSelected ? AppColors.accent : Colors.grey.shade300,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  labelStyle: TextStyle(
                    color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                    fontSize: 10.dp,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.w),
                );
              }).toList(),
            ),
          ),
        ),
        if (_localInterests.isEmpty)
          Padding(
            padding: EdgeInsets.only(top: 1.h, right: 2.w),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.red.shade400, size: 4.w),
                SizedBox(width: 1.w),
                Text(
                  'الرجاء اختيار اهتمام واحد على الأقل',
                  style: TextStyle(color: Colors.red.shade600, fontSize: 10.dp),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
