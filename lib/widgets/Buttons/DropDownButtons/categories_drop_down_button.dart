import 'package:ewm/db_manager.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CategoriesDropDownButton extends StatefulWidget {
  CategoriesDropDownButton(
      {required this.itemId,
      required this.onChangedFunction,
      required this.categoriesData,
      required this.dropdownValue,
      Key? key})
      : super(key: key);
  String? dropdownValue;
  List<String> categoriesAsList = [];
  final List<Map<String, dynamic>> categoriesData;
  final int itemId;
  final Function onChangedFunction;

  final DbManager dbManager = DbManager.instance;

  @override
  State<CategoriesDropDownButton> createState() =>
      _CategoriesDropDownButtonState();
}

class _CategoriesDropDownButtonState extends State<CategoriesDropDownButton> {
  int _indexAsCategoryIdAsInt = 0;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.categoriesData.length; i++) {
      widget.categoriesAsList.add(widget.categoriesData[i]
              [widget.dbManager.categoriesColumnNameCategoryName]
          .toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      hint: const Text('Kategorie'),
      value: widget.dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 3,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? newValue) {
        setState(
          () {
            widget.dropdownValue = newValue!;
            _indexAsCategoryIdAsInt =
                widget.categoriesAsList.indexOf(newValue) + 1;
            widget.onChangedFunction(
                itemId: widget.itemId,
                categoryIdValue: _indexAsCategoryIdAsInt);
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
