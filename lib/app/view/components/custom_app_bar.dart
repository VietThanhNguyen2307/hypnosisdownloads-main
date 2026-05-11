// ignore_for_file: avoid_field_initializers_in_const_classes

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hypnosis_downloads/app/view/common/assets.dart';
import 'package:hypnosis_downloads/app/view/common/colors.dart';
import 'package:hypnosis_downloads/app/view/components/text/body_medium_text.dart';
import 'package:hypnosis_downloads/app/view/widgets/default_icon_button.dart';

enum CustomAppBarType {
  primary,
  secondary,
  search,
  withoutTitle,
  withTextButton,
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar.primary({
    Key? key,
    required String title,
    Color? backgroundColor,
    Color? titleColor,
    this.actions = const [],
  })  : _appBarType = CustomAppBarType.primary,
        _title = title,
        _backgroundColor = backgroundColor,
        _titleColor = titleColor,
        _backButtonBehaviour = null,
        _centerTitle = false,
        _controller = null,
        _onClearTap = null,
        _titleClickable = false,
        _onChanged = null,
        super(key: key);

  const CustomAppBar.secondary({
    Key? key,
    required String title,
    Color? backgroundColor,
    Color? titleColor,
    bool titleClickable = false,
    this.actions = const [],
    VoidCallback? onBackButtonPressed,
    bool centerTitle = true,
  })  : _appBarType = CustomAppBarType.secondary,
        _title = title,
        _backgroundColor = backgroundColor,
        _titleColor = titleColor,
        _backButtonBehaviour = onBackButtonPressed,
        _centerTitle = centerTitle,
        _controller = null,
        _titleClickable = titleClickable,
        _onClearTap = null,
        _onChanged = null,
        super(key: key);

  const CustomAppBar.search({
    Key? key,
    TextEditingController? controller,
    VoidCallback? onClearTap,
    Function(String)? onChanged,
  })  : _appBarType = CustomAppBarType.search,
        _backgroundColor = null,
        _titleColor = null,
        _backButtonBehaviour = null,
        _centerTitle = false,
        _title = null,
        _controller = controller,
        _onClearTap = onClearTap,
        _titleClickable = false,
        actions = const [],
        _onChanged = onChanged,
        super(key: key);

  final CustomAppBarType _appBarType;
  final String? _title;
  final Color? _backgroundColor;
  final Color? _titleColor;
  final List<Widget> actions;
  final VoidCallback? _backButtonBehaviour;
  final bool _centerTitle;
  final VoidCallback? _onClearTap;
  final TextEditingController? _controller;
  final bool _titleClickable;
  final Function(String)? _onChanged;

  @override
  Widget build(BuildContext context) {
    switch (_appBarType) {
      case CustomAppBarType.primary:
        return buildPrimaryAppBar();
      case CustomAppBarType.secondary:
        return buildSecondaryAppBar(context);
      case CustomAppBarType.search:
        return buildSearchAppBar(context);
      case CustomAppBarType.withoutTitle:
        return Container();
      case CustomAppBarType.withTextButton:
        return Container();
    }
  }

  Widget buildPrimaryAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: _backgroundColor ?? ComponentColors.appBarBackgroundColor,
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  SvgPicture.asset(Assets.logoDefault),
                  const SizedBox(width: 8),
                  if (_titleColor != null)
                    Expanded(
                      child: BodyMediumText(
                        _title ?? '',
                        color: _titleColor,
                        textAlign: !_centerTitle ? TextAlign.start : null,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                    )
                  else
                    Expanded(
                      child: BodyMediumText.dark(
                        _title ?? '',
                        maxLines: 1,
                        textAlign: !_centerTitle ? TextAlign.start : null,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                    )
                ],
              ),
            ),
            if (actions.isNotEmpty)
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: actions,
                ),
              )
            else
              Container(),
          ],
        ),
      ),
    );
  }

  Widget buildSecondaryAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: _backgroundColor ?? ComponentColors.appBarBackgroundColor,
      ),
      child: SafeArea(
        child: Row(
          children: [
            DefaultIconButton(
              SvgPicture.asset(Assets.shortArrowLeft),
              onTap: () {
                if (_backButtonBehaviour != null) {
                  _backButtonBehaviour?.call();
                } else {
                  Navigator.of(context).pop();
                }
              },
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Row(
                mainAxisAlignment: _centerTitle
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.start,
                children: [
                  if (_titleColor != null)
                    Expanded(
                      child: BodyMediumText(
                        _title ?? '',
                        color: _titleColor,
                        textAlign: !_centerTitle ? TextAlign.start : null,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                    )
                  else
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          if (_backButtonBehaviour != null && _titleClickable) {
                            _backButtonBehaviour?.call();
                          }
                        },
                        child: BodyMediumText.dark(
                          _title ?? '',
                          maxLines: 1,
                          textAlign: !_centerTitle ? TextAlign.start : null,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            ...[const SizedBox(width: 16), ...actions],
          ],
        ),
      ),
    );
  }

  Widget buildSearchAppBar(context) {
    return SafeArea(
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: _backgroundColor ?? ComponentColors.appBarBackgroundColor,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SvgPicture.asset(
              IconsOutlined.search,
              width: 24,
              height: 24,
              color: ComponentColors.secondaryIconColor,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: ComponentColors.enableTextFormBackgroundColor,
                    hintText: 'Search',
                    hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: ComponentColors.secondaryIconColor,
                        ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(80),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                  onChanged: _onChanged,
                ),
              ),
            ),
            DefaultIconButton(
              SvgPicture.asset(
                IconsOutlined.close,
                width: 24,
                height: 24,
                color: ComponentColors.defaultIconColor,
              ),
              onTap: _onClearTap,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(40);
}
