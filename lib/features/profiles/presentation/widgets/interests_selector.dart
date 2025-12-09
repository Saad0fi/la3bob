import 'package:flutter/material.dart';
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
        const Text(
          'اهتمامات الطفل',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          textDirection: TextDirection.rtl,
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(
              color: _localInterests.isEmpty ? Colors.red : Colors.grey,
              width: _localInterests.isEmpty ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            textDirection: TextDirection.rtl,
            children: InterestsConstants.availableInterests.map((interest) {
              final isSelected = _localInterests.contains(interest);
              return FilterChip(
                label: Text(interest),
                selected: isSelected,
                onSelected: (selected) => _toggleInterest(interest, selected),
                selectedColor: Colors.blue.shade100,
                checkmarkColor: Colors.blue.shade700,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.blue.shade700 : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                padding: const EdgeInsets.all(12),
              );
            }).toList(),
          ),
        ),
        if (_localInterests.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8, right: 4),
            child: Text(
              'الرجاء اختيار اهتمام واحد على الأقل',
              style: TextStyle(color: Colors.red.shade700, fontSize: 12),
              textDirection: TextDirection.rtl,
            ),
          ),
      ],
    );
  }
}
