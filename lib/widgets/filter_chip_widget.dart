import 'package:flutter/material.dart';
import '../style/colors.dart';

class FilterChipWidget extends StatefulWidget {
  final String name;
  final List list;
  bool isSelected;

    FilterChipWidget({Key? key,
    required this.name,
    this.isSelected = false,
    required this.list,
  }) : super(key: key);

  @override
  State<FilterChipWidget> createState() => _FilterChipWidgetState();
}

class _FilterChipWidgetState extends State<FilterChipWidget> {

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(
        widget.name,
        style: const TextStyle(color: defColor),
      ),
      selected: widget.isSelected,
      backgroundColor: secColor.withOpacity(0.5),
      selectedColor: secColor.withOpacity(0.8),
      padding: const EdgeInsetsDirectional.all(10),
      checkmarkColor: defColor,
      onSelected: (v) {
        setState(() {
          widget.isSelected = !widget.isSelected;
          if(widget.isSelected){
            widget.list.add(widget.name);
          }else{
            widget.list.remove(widget.name);
          }
        },
        );
      },
    );
  }
}