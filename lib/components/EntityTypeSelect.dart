import 'package:flutter/material.dart';
import 'package:witcher_guide/enums/index.dart';

class EntityTypeSelect extends StatelessWidget {
  const EntityTypeSelect(
      {Key? key,
      required this.entityType,
      required this.handleSelect,
      isRequiredValue})
      : super(key: key);

  final EntityType? entityType;
  final bool isRequiredValue = false;
  final void Function(EntityType) handleSelect;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<EntityType>(
      isExpanded: true,
      value: entityType,
      elevation: 16,
      underline: Container(
        height: 1,
        color: Colors.black54,
      ),
      onChanged: (EntityType? value) {
        if (value != null) {
          handleSelect(value);
        }
      },
      items:
          // (isRequiredValue ? EntityType.values : [null, ...EntityType.values]) // TODO
          EntityType.values
              .map<DropdownMenuItem<EntityType>>((EntityType? type) {
        return DropdownMenuItem(
          value: type,
          child: Text(type != null
              ? EntityTypeExtension(type).displayTitle
              : "Select type..."),
        );
      }).toList(),
    );
  }
}
