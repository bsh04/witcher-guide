import 'package:flutter/material.dart';
import 'package:witcher_guide/components/EntityTypeSelect.dart';
import 'package:witcher_guide/enums/index.dart';

class MainScreenFilters extends StatefulWidget {
  final bool isOpenFilters;
  final EntityType? initEntityType;
  final void Function(EntityType type) handleApplyFilters;
  final void Function() handleResetFilters;

  const MainScreenFilters(
      {Key? key, required this.isOpenFilters, required this.handleApplyFilters, required this.handleResetFilters, this.initEntityType})
      : super(key: key);

  @override
  State<MainScreenFilters> createState() => _MainScreenFiltersState();
}

class _MainScreenFiltersState extends State<MainScreenFilters> {
  late EntityType _entityType = EntityType.CHARACTER;

  @override
  void initState() {
    super.initState();
    if (widget.initEntityType != null) {
      setState(() {
        _entityType = widget.initEntityType!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    if (!widget.isOpenFilters) {
      return const Center();
    }
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: Colors.black38)),
      width: width,
      height: 300,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 0),
            child: Text("Entity type"),
          ),
          SizedBox(
            width: width,
            child: EntityTypeSelect(
              isRequiredValue: false,
              entityType: _entityType,
              handleSelect: (EntityType value) {
                setState(() {
                  _entityType = value;
                });
              },
            ),
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  onPressed: () {
                    widget.handleApplyFilters(_entityType);
                  },
                  child: Text("Apply Filters")),
              TextButton(
                  onPressed: () {
                    widget.handleResetFilters();
                  },
                  child: Text("Reset Filters"))
            ],
          ),
        ],
      ),
    );
  }
}
