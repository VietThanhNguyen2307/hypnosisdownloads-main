import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hypnosis_downloads/app/view/common/assets.dart';
import 'package:hypnosis_downloads/app/view/common/colors.dart';
import 'package:hypnosis_downloads/app/view/widgets/default_input_field.dart';

class SearchTextFormField extends StatefulWidget {
  const SearchTextFormField({
    Key? key,
    this.hitText,
    this.enabled = true,
    this.obscureText = false,
    this.controller,
    this.errorText,
    this.onChanged,
    this.onClear,
  }) : super(key: key);

  final String? hitText;
  final bool enabled;
  final bool obscureText;
  final TextEditingController? controller;
  final String? errorText;
  final void Function(String)? onChanged;
  final VoidCallback? onClear;

  @override
  State<SearchTextFormField> createState() => _SearchTextFormFieldState();
}

class _SearchTextFormFieldState extends State<SearchTextFormField> {
  final FocusNode _focus = FocusNode();
  bool showCloseIcon = false;

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focus
      ..removeListener(_onFocusChange)
      ..dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      showCloseIcon = _focus.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultInputField(
      hintText: 'Search',
      enabled: widget.enabled,
      focusNode: _focus,
      obscureText: widget.obscureText,
      controller: widget.controller,
      errorText: widget.errorText,
      onChanged: widget.onChanged,
      prefixIcon: Padding(
        padding: const EdgeInsets.all(8) + const EdgeInsets.only(left: 8),
        child: SvgPicture.asset(
          IconsOutlined.search,
          width: 24,
          height: 24,
          color: ComponentColors.secondaryIconColor,
        ),
      ),
      suffixIcon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: showCloseIcon
            ? GestureDetector(
                onTap: () {
                  widget.controller?.clear.call();
                  widget.onClear?.call();
                  _focus.unfocus();
                },
                child: SvgPicture.asset(
                  IconsOutlined.close,
                  width: 24,
                  height: 24,
                  color: ComponentColors.secondaryIconColor,
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}
