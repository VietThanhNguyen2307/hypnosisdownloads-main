import 'package:flutter/material.dart';
import 'package:hypnosis_downloads/app/view/common/colors.dart';
import 'package:hypnosis_downloads/app/view/common/shadows.dart';

class GroupTab extends StatefulWidget {
  const GroupTab({Key? key, required this.items, required this.onChange})
      : super(key: key);

  final List<String> items;
  final ValueChanged<int> onChange;

  @override
  State<GroupTab> createState() => _GroupTabState();
}

class _GroupTabState extends State<GroupTab> {
  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: ComponentColors.groupTabBackgroundColor,
      ),
      child: Row(
        children: List<Widget>.generate(
          widget.items.length,
          (index) => GroupTabPin(
            widget.items[index],
            enabled: index == activeIndex,
            onTap: () {
              setState(() {
                activeIndex = index;
                widget.onChange(activeIndex);
              });
            },
          ),
        ),
      ),
    );
  }
}

class GroupTabPin extends StatelessWidget {
  const GroupTabPin(
    this.data, {
    Key? key,
    this.onTap,
    this.enabled = false,
  }) : super(key: key);

  final String data;
  final VoidCallback? onTap;
  final bool enabled;

  static final _bordeRadius = BorderRadius.circular(8);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: _bordeRadius,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: enabled ? ComponentColors.secondaryButtonColor : null,
            borderRadius: _bordeRadius,
            boxShadow: [
              Shadows.groupPin,
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                data,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: ComponentColors.defaultBodyTextColor,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
