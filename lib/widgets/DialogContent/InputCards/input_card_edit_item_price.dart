import 'package:flutter/material.dart';

class InputCardEditItemPrice extends StatelessWidget {
  InputCardEditItemPrice(
      {Key? key,
      required this.updateItemPriceinSqliteDB,
      required this.itemId,
      required this.editItemPriceTextFieldInitValue})
      : super(key: key);
  final Function updateItemPriceinSqliteDB;
  final int itemId;
  final double editItemPriceTextFieldInitValue;
  final _priceController = TextEditingController();
  final _formKeyPriceInput = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    _priceController.text = editItemPriceTextFieldInitValue.toStringAsFixed(2);
    return Card(
      elevation: 5,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Form(
                key: _formKeyPriceInput,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      autofocus: true,
                      decoration: const InputDecoration(labelText: 'Preis'),
                      controller: _priceController,
                      keyboardType: TextInputType.datetime,
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'Bitte einen Preis eingeben!';
                        }
                        value = value.replaceAll(r",", ".");
                        // double d = 2.3456789;
                        double d = double.parse(value);
                        String inString = d.toStringAsFixed(2); // '2.35'
                        double inDouble = double.parse(inString);
                        value = inString;
                        try {
                          if (double.parse(value) > 999.99) {
                            return 'Bitte einen realen Artikelpreis eingeben!';
                          }
                          _priceController.text = value.toString();
                          return null;
                        } catch (error) {
                          return 'Bitte einen Preis eingeben!';
                        }
                      },
                    )
                  ],
                ),
              ),
              TextButton(
                child: const Text(
                  'Fertig',
                  style: TextStyle(color: Colors.purple),
                ),
                onPressed: () {
                  debugPrint('edit price fertig bnutten was pressed');
                  String value = _priceController.text;
                  if (_formKeyPriceInput.currentState!.validate()) {
                    debugPrint('submitData()');
                    updateItemPriceinSqliteDB(
                      itemId: itemId,
                      newItemPrice: _priceController.text,
                    );
                  }
                  if (_formKeyPriceInput.currentState!.validate()) {
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
