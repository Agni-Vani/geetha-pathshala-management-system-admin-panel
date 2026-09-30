import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_field_decoration.dart';

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

    return LayoutBuilder(
      builder: (context, constraints) {
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
                  decoration: AppFieldDecoration.build(
                    context,
                    hint: hint,
                    suffixWidget: AppFieldDecoration.suffixIcon(
                      context,
                      Icons.arrow_drop_down,
                      size: 24,
                    ),
                  ),
                );
              },
              optionsViewBuilder: (context, onSelected, options) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    color: colors.backgroundColor,
                    elevation: 6,
                    shadowColor: colors.shadowColor,
                    borderRadius: BorderRadius.circular(8),
                    clipBehavior: Clip.antiAlias,
                    child: Container(
                      width: constraints.maxWidth,
                      constraints: const BoxConstraints(maxHeight: 220),
                      decoration: BoxDecoration(border: Border.all(color: colors.borderColor)),
                      child: ListView.separated(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: options.length,
                        separatorBuilder: (_, _) => Divider(height: 1, color: colors.dividerColor),
                        itemBuilder: (context, index) {
                          final option = options.elementAt(index);
                          return InkWell(
                            onTap: () => onSelected(option),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              child: Text(
                                option,
                                style: TextStyle(fontSize: 13, color: colors.textColor),
                              ),
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
      },
    );
  }
}
