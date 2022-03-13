import 'package:flutter/material.dart';

class InputCardEditItemName extends StatelessWidget {
  InputCardEditItemName(
      {Key? key,
      required this.updateItemNameinSqliteDB,
      required this.itemId,
      required this.itemNameTextFieldInitValue})
      : super(key: key) {
    titleController.text = itemNameTextFieldInitValue;
  }

  final Function updateItemNameinSqliteDB;
  final int itemId;
  final String itemNameTextFieldInitValue;
  final titleController = TextEditingController();
  final _formKeyTitleInput = GlobalKey<FormState>();

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
                key: _formKeyTitleInput,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      autofocus: true,
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
              TextButton(
                child: const Text(
                  'Fertig',
                  style: TextStyle(color: Colors.purple),
                ),
                onPressed: () {
                  if (_formKeyTitleInput.currentState!.validate()) {
                    debugPrint('submitData()');
                    updateItemNameinSqliteDB(
                      itemId: itemId,
                      newItemName: titleController.text,
                    );
                  }
                  if (_formKeyTitleInput.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Artikeldaten wurden aktualisiert'),
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
