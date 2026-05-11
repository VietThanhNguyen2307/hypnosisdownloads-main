import 'package:flutter/material.dart';
import 'package:hypnosis_downloads/users/profile/view/components/dropdown_settings_list_view_item.dart';

class DropdownSettingsListView extends StatelessWidget {
  const DropdownSettingsListView({
    Key? key,
    required this.items,
    this.physics,
  }) : super(key: key);

  final List<DropdownSettingsListViewItem> items;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      shrinkWrap: true,
      physics: physics,
      itemBuilder: (BuildContext context, int index) {
        return items[index];
      },
    );
  }
}
