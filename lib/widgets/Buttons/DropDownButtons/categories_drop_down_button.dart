import 'package:flutter/material.dart';

class CategoriesDropDownButton extends StatefulWidget {
  CategoriesDropDownButton(
      {required this.updateCategoryIdInItemData,
      required this.categoriesFromDBasList,
      required this.dropdownValue,
      Key? key})
      : super(key: key);
  String? dropdownValue;
  List<String> categoriesFromDBasList = [];
  Function updateCategoryIdInItemData;

  @override
  State<CategoriesDropDownButton> createState() =>
      _CategoriesDropDownButtonState();
}

class _CategoriesDropDownButtonState extends State<CategoriesDropDownButton> {
  final String _dropDownValue = 'Brot';
  int _index = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: widget.dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? newValue) {
        setState(() {
          widget.dropdownValue = newValue!;
          _index = widget.categoriesFromDBasList.indexOf(newValue);
        });
      },
      items: widget.categoriesFromDBasList
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
