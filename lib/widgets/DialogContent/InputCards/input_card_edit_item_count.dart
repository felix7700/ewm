import 'package:ewm/db_manager.dart';
import 'package:flutter/material.dart';

class InputCardEditItemCount extends StatefulWidget {
  InputCardEditItemCount(
      {Key? key,
      required this.itemId,
      required this.itemCountValue,
      required this.dataUpdatedFunction,
      required this.dialogbuildContext})
      : super(key: key);
  final int itemId;
  int itemCountValue;
  final Function dataUpdatedFunction;
  final BuildContext dialogbuildContext;

  @override
  State<InputCardEditItemCount> createState() => _InputCardEditItemCountState();
}

class _InputCardEditItemCountState extends State<InputCardEditItemCount> {
  final _itemCountController = TextEditingController();
  final DbManager dbManager = DbManager.instance;
  String _titleText = 'Bestand in Stück:\n';

  void _increaseItemCount(
      {required int itemId, required int increaseValue}) async {
    String _table = dbManager.inventoryTableName;
    String _columnToIncrease = dbManager.inventoryColumnNameItemCount;
    String _inventoryColumnNameItemID = dbManager.inventoryColumnNameItemID;
    String _itemId = itemId.toString();
    widget.itemCountValue += increaseValue;

    String _queryString =
        'UPDATE $_table SET $_columnToIncrease = $_columnToIncrease + $increaseValue WHERE $_inventoryColumnNameItemID = $_itemId';
    var _resultErrorList = await dbManager.rawQuery(queryString: _queryString);
    if (_resultErrorList.isEmpty) {
      setState(() {});
    } else {
      _titleText = _resultErrorList.toString();
    }
  }

  void _decreaseItemCount(
      {required int itemId, required int decreaseValue}) async {
    String _table = dbManager.inventoryTableName;
    String _columnToIncrease = dbManager.inventoryColumnNameItemCount;
    String _inventoryColumnNameItemID = dbManager.inventoryColumnNameItemID;
    String _itemId = itemId.toString();
    widget.itemCountValue -= decreaseValue;
    if (widget.itemCountValue < 0) {
      return;
    }
    String _queryString =
        'UPDATE $_table SET $_columnToIncrease = $_columnToIncrease - $decreaseValue WHERE $_inventoryColumnNameItemID = $_itemId';
    var _resultErrorList = await dbManager.rawQuery(queryString: _queryString);
    if (_resultErrorList.isEmpty) {
      setState(() {});
    } else {
      _titleText = _resultErrorList.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    _itemCountController.text = widget.itemCountValue.toString();
    return Card(
      elevation: 5,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: SizedBox(
          height: 120,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.remove_circle_rounded,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    color: Colors.blue,
                    onPressed: () => _decreaseItemCount(
                        itemId: widget.itemId, decreaseValue: 1),
                  ),
                  Column(
                    children: [
                      const Text('Bestand in Stück:\n'),
                      Text(
                        widget.itemCountValue.toString(),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.add_circle_rounded,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    color: Colors.blue,
                    onPressed: () => _increaseItemCount(
                        itemId: widget.itemId, increaseValue: 1),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                onPressed: () => widget.dataUpdatedFunction(),
                child: const Text(
                  'Fertig',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
