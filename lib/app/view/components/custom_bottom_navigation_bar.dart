import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hypnosis_downloads/app/home/page_index_provider.dart';
import 'package:hypnosis_downloads/app/view/common/colors.dart';
import 'package:hypnosis_downloads/app/view/common/shadows.dart';
import 'package:provider/provider.dart';

class CustomNavbarItemModel {
  CustomNavbarItemModel({required this.icon, required this.label});

  final String icon;
  final String label;
}

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({
    Key? key,
    required this.items,
    this.color = ComponentColors.bottomNavbarItemColor,
    this.activeColor = ComponentColors.bottomNavbarActiveItemColor,
    this.onTap,
  })  : assert(items.length > 0, 'items can`t be empty'),
        super(key: key);

  final List<CustomNavbarItemModel> items;
  final Color color;
  final Color activeColor;
  final ValueChanged<int>? onTap;

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  static const _bottomPadding = 8.0;

  // In different devices we don`t have an home button on screen,
  // so we need to calculate that padding by hands
  double calculateBottomPadding(BuildContext context) {
    if (MediaQuery.of(context).padding.bottom <= _bottomPadding) {
      return _bottomPadding;
    }

    return MediaQuery.of(context).padding.bottom;
  }

  @override
  Widget build(BuildContext context) {
    return Selector(
      selector: (context, provider) =>
          Provider.of<PageIndexProvider>(context).activeIndex,
      builder: ((context, value, child) {
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: Colors.transparent, // Set status bar color
          statusBarIconBrightness: value == 0
              ? Brightness.light
              : Brightness.dark, // Set status bar icons color
        ));
        return Container(
          padding: EdgeInsets.only(
            top: 8,
            bottom: calculateBottomPadding(context),
          ),
          decoration: BoxDecoration(
            color: ComponentColors.bottomNavbarColor,
            boxShadow: [Shadows.navbar],
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(20),
              topLeft: Radius.circular(20),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List<Widget>.generate(
              widget.items.length,
              (index) => GestureDetector(
                onTap: () {
                  widget.onTap?.call(index);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      widget.items[index].icon,
                      color: index == value ? widget.activeColor : widget.color,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.items[index].label,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: index == value
                                ? widget.activeColor
                                : widget.color,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
