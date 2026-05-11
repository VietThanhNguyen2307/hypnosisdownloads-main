import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hypnosis_downloads/app/view/common/assets.dart';
import 'package:hypnosis_downloads/app/view/common/colors.dart';

class DefaultInputField extends StatelessWidget {
  const DefaultInputField({
    Key? key,
    this.hintText,
    this.enabled = true,
    this.obscureText = false,
    this.controller,
    this.errorText,
    this.onChanged,
    this.prefixIcon,
    this.suffixIcon,
    this.focusNode,
    this.textCapitalization,
    this.keyboardType,
    this.autofillHints,
  }) : super(key: key);

  final String? hintText;
  final bool enabled;
  final bool obscureText;
  final TextEditingController? controller;
  final String? errorText;
  final void Function(String)? onChanged;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final FocusNode? focusNode;
  final TextCapitalization? textCapitalization;
  final TextInputType? keyboardType;
  final Iterable<String>? autofillHints;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          textInputAction: TextInputAction.next,
          onEditingComplete: () => FocusScope.of(context).nextFocus(),
          keyboardType: keyboardType,
          enabled: enabled,
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(
            filled: true,
            hintText: hintText,
            fillColor: enabled
                ? ComponentColors.enableTextFormBackgroundColor
                : ComponentColors.disabledTextFormBackgroundColor,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
          ),
          cursorHeight: 20,
          style: Theme.of(context).textTheme.bodyMedium,
          obscureText: obscureText,
          obscuringCharacter: '*',
          autocorrect: false,
          enableSuggestions: false,
          onChanged: onChanged,
          textCapitalization: textCapitalization ?? TextCapitalization.none,
          autofillHints: autofillHints,
        ),
        const SizedBox(height: 6),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: errorText != null
              ? Row(
                  children: [
                    SvgPicture.asset(
                      IconsBold.warning2,
                      color: ComponentColors.errorBorderColor,
                      height: 10,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      errorText ?? '',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: ComponentColors.errorBorderColor),
                    )
                  ],
                )
              : Container(),
        )
      ],
    );
  }
}
