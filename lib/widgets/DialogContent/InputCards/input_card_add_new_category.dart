import 'package:ewm/db_manager.dart';
import 'package:flutter/material.dart';

class AddNewCategoryCard extends StatelessWidget {
  AddNewCategoryCard({Key? key, required this.addNewCategoryFunction})
      : super(key: key);
  final Function addNewCategoryFunction;
  final categoryNameTextEditingController = TextEditingController();
  final _formKeyCategoryNameInput = GlobalKey<FormState>();

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
              Form(
                key: _formKeyCategoryNameInput,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      autofocus: true,
                      decoration:
                          const InputDecoration(labelText: 'Kategoriename'),
                      controller: categoryNameTextEditingController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Bitte einen Kategorienamen eingeben!';
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
              TextButton(
                child: const Text(
                  'Kategorie hinzufügen',
                  style: TextStyle(color: Colors.purple),
                ),
                onPressed: () {
                  if (_formKeyCategoryNameInput.currentState!.validate()) {
                    debugPrint('submitData()');
                    DbManager dbManager = DbManager.instance;
                    Map<String, dynamic> newCategoryRow = {
                      dbManager.categoriesColumnNameCategoryName:
                          categoryNameTextEditingController.text
                    };
                    debugPrint(
                        'send addNewCategoryFunction(newCategoryRow):   ' +
                            newCategoryRow.toString());
                    addNewCategoryFunction(newCategoryRow: newCategoryRow);
                    Navigator.of(context).pop();
                  }
                  if (_formKeyCategoryNameInput.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Kategorie wurde hinzugefügt'),
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
