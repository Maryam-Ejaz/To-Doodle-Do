import 'package:flutter/material.dart';
import 'package:Todo_list_App/Backend/data/colors.dart';

class CustomDropdownField extends StatelessWidget {
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool disableBorder;
  final bool readOnly;

  const CustomDropdownField({
    Key? key,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.disableBorder = false,
    this.readOnly = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(15),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        icon: const Icon(Icons.arrow_drop_down, color: kPrimaryColor),
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          hintText: hintText,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
        ),
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,

            child: Center(
              child: Text(
                item,
                style: TextStyle(
                  color: kBlack, // Match the text color of your design
                  fontSize: 16.0, // Adjust font size as needed
                ),
              ),
            ),
          );
        }).toList(),
        onChanged: readOnly ? null : onChanged,
      ),
    );
  }
}
