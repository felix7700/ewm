import 'package:ewm/db_manager.dart';
import 'package:ewm/widgets/Buttons/DropDownButtons/categories_drop_down_button.dart';
import 'package:flutter/material.dart';
import '../../FormFields/form_field_price.dart';

class AddNewItemCard extends StatelessWidget {
  AddNewItemCard(
      {Key? key,
      required this.addItemToInvetoryAndRefreshDataOnDisplayFunction,
      required this.categoriesData})
      : super(key: key);
  final Function addItemToInvetoryAndRefreshDataOnDisplayFunction;
  List<Map<String, dynamic>> categoriesData;

  final titleController = TextEditingController();
  final _formKeyTitleInput = GlobalKey<FormState>();
  final FormFieldPrice formFieldPrice = FormFieldPrice(autofocusValue: false);

  final DbManager _dbManager = DbManager.instance;

  void _addItemToInvetoryAndRefreshDataOnDisplayFunction() async {
    debugPrint('_addItemToInventoryTable');

    Map<String, dynamic> _newItemDataRow = {
      // inventoryColumnNameItemID: >auto increment if insert a new row<,
      _dbManager.inventoryColumnNameCategoryId: 1,
      _dbManager.inventoryColumnNameItemName: titleController.text,
      _dbManager.inventoryColumnNameItemPrice:
          formFieldPrice.priceController.text,
      _dbManager.inventoryColumnNameItemCount: 0
    };

    addItemToInvetoryAndRefreshDataOnDisplayFunction(
        newItemdataRow: _newItemDataRow);
  }

  void _categoryOnChangedFunction(
      {required int itemId, required int categoryIdValue}) {
    debugPrint('categoryIdValue: $categoryIdValue');
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Center(
                child: CategoriesDropDownButton(
                  itemId: 0,
                  onChangedFunction: _categoryOnChangedFunction,
                  categoriesData: categoriesData,
                  dropdownValue: null,
                ),
              ),
              Form(
                key: _formKeyTitleInput,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Artikelname'),
                      controller: titleController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Bitte einen Artikelnamen eingeben!';
                        }
                        if (value.length > 20) {
                          return 'Maximal 20 Zeichen!';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              formFieldPrice,
              TextButton(
                child: const Text(
                  'Artikel hinzufügen',
                  style: TextStyle(color: Colors.purple),
                ),
                onPressed: () {
                  if (_formKeyTitleInput.currentState!.validate() &&
                      formFieldPrice.formKeyPriceInput.currentState!
                          .validate()) {
                    debugPrint('submitData()');
                    _addItemToInvetoryAndRefreshDataOnDisplayFunction();
                  }
                  if (_formKeyTitleInput.currentState!.validate() &&
                      formFieldPrice.formKeyPriceInput.currentState!
                          .validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Artikel wurde hinzugefügt'),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
