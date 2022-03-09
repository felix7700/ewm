import 'package:ewm/db_manager.dart';
import 'package:flutter/material.dart';

class CategoriesDropDownButton extends StatefulWidget {
  CategoriesDropDownButton(
      {required this.itemData,
      required this.updateCategoryIdInItemDataFunction,
      required this.categoriesFromDBasList,
      required this.dropdownValue,
      Key? key})
      : super(key: key);
  String? dropdownValue;
  final List<String> categoriesFromDBasList;
  final Map<String, dynamic> itemData;
  final Function updateCategoryIdInItemDataFunction;

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
            _indexAsCategoryId =
                widget.categoriesFromDBasList.indexOf(newValue);
            int _itemId = widget.itemData[_dbManager.inventoryColumnNameItemID];
            widget.updateCategoryIdInItemDataFunction(
                itemId: _itemId, newCategoryId: _indexAsCategoryId);
          },
        );
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
