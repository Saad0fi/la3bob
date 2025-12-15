import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
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
      crossAxisAlignment: .start,
      children: [
        Text(
          'اهتمامات الطفل',
          style: TextStyle(fontSize: 12.dp, fontWeight: FontWeight.bold),
          textDirection: TextDirection.rtl,
        ),
        SizedBox(height: 2.h),
        Container(
          padding: .all(3.w),
          decoration: BoxDecoration(
            border: Border.all(
              color: _localInterests.isEmpty ? Colors.red : Colors.grey,
              width: _localInterests.isEmpty ? 0.5.w : 0.3.w,
            ),
            borderRadius: .circular(2.w),
          ),
          child: Wrap(
            spacing: 2.w,
            runSpacing: 2.h,
            textDirection: TextDirection.rtl,
            children: InterestsConstants.availableInterests.map((interest) {
              final isSelected = _localInterests.contains(interest);
              return FilterChip(
                label: Text(interest, style: TextStyle(fontSize: 10.dp)),
                selected: isSelected,
                onSelected: (selected) => _toggleInterest(interest, selected),
                selectedColor: Colors.blue.shade100,
                checkmarkColor: Colors.blue.shade700,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.blue.shade700 : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 10.dp,
                ),
                padding: .all(2.w),
              );
            }).toList(),
          ),
        ),
        if (_localInterests.isEmpty)
          Padding(
            padding: .all(2.w),
            child: Text(
              'الرجاء اختيار اهتمام واحد على الأقل',
              style: TextStyle(color: Colors.red.shade700, fontSize: 10.dp),
              textDirection: TextDirection.rtl,
            ),
          ),
      ],
    );
  }
}
