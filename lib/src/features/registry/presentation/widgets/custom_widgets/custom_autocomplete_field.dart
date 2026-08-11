import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';

class CustomAutocompleteField extends StatelessWidget {
  final String label;
  final String hint;
  final bool isRequired;
  final bool enabled;
  final List<String> options;
  final String? value;
  final ValueChanged<String> onChanged;

  const CustomAutocompleteField({
    super.key,
    required this.label,
    required this.hint,
    this.isRequired = false,
    this.enabled = true,
    required this.options,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: colors.textColor,
            ),
            children: [
              if (isRequired)
                TextSpan(text: ' *', style: TextStyle(color: colors.errorColor)),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Autocomplete<String>(
          initialValue: TextEditingValue(text: value ?? ''),
          optionsBuilder: (textEditingValue) {
            if (!enabled) return const Iterable<String>.empty();
            if (textEditingValue.text.isEmpty) return options;
            return options.where(
              (option) => option.toLowerCase().contains(textEditingValue.text.toLowerCase()),
            );
          },
          onSelected: onChanged,
          fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
            return TextFormField(
              controller: controller,
              focusNode: focusNode,
              enabled: enabled,
              onChanged: onChanged,
              style: TextStyle(fontSize: 13, color: colors.textColor),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(color: colors.hintColor, fontSize: 13),
                suffixIcon: Icon(Icons.arrow_drop_down, color: colors.hintColor),
                filled: true,
                fillColor: colors.tileColor,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: colors.borderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: colors.borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: colors.primaryColor),
                ),
              ),
            );
          },
          optionsViewBuilder: (context, onSelected, options) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(8),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 220, maxWidth: 320),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      final option = options.elementAt(index);
                      return InkWell(
                        onTap: () => onSelected(option),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          child: Text(option, style: const TextStyle(fontSize: 13)),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
