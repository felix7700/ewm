import 'package:ewm/widgets/FormFields/form_field_price.dart';
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
  final FormFieldPrice formFieldPrice = FormFieldPrice();

  @override
  Widget build(BuildContext context) {
    formFieldPrice.priceController.text =
        editItemPriceTextFieldInitValue.toStringAsFixed(2);
    return Card(
      elevation: 5,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              formFieldPrice,
              TextButton(
                child: const Text(
                  'Fertig',
                  style: TextStyle(color: Colors.purple),
                ),
                onPressed: () {
                  String value = formFieldPrice.priceController.text;
                  if (formFieldPrice.formKeyPriceInput.currentState!
                      .validate()) {
                    debugPrint('submitData()');
                    updateItemPriceinSqliteDB(
                      itemId: itemId,
                      newItemPrice: formFieldPrice.priceController.text,
                    );
                  }
                  if (formFieldPrice.formKeyPriceInput.currentState!
                      .validate()) {
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
