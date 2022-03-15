import 'package:ewm/db_manager.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CategoriesDropDownButton extends StatefulWidget {
  CategoriesDropDownButton(
      {required this.itemId,
      required this.updateCategoryIdInItemDataFunction,
      required this.categoriesData,
      this.dropdownValue,
      Key? key})
      : super(key: key);
  String? dropdownValue;
  List<String> categoriesAsList = [];
  final List<Map<String, dynamic>> categoriesData;
  final int itemId;
  final Function updateCategoryIdInItemDataFunction;

  final DbManager dbManager = DbManager.instance;

  @override
  State<CategoriesDropDownButton> createState() =>
      _CategoriesDropDownButtonState();
}

class _CategoriesDropDownButtonState extends State<CategoriesDropDownButton> {
  int _indexAsCategoryId = 0;
  final DbManager _dbManager = DbManager.instance;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.categoriesData.length; i++) {
      widget.categoriesAsList.add(widget.categoriesData[i]
              [widget.dbManager.categoriesColumnNameCategoryName]
          .toString());
    }
    widget.dropdownValue ??= widget.categoriesAsList[0];
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
        setState(
          () {
            widget.dropdownValue = newValue!;
            _indexAsCategoryId = widget.categoriesAsList.indexOf(newValue) + 1;
            widget.updateCategoryIdInItemDataFunction(
                itemId: widget.itemId, newCategoryId: _indexAsCategoryId);
          },
        );
      },
      items:
          widget.categoriesAsList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
