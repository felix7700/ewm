import 'package:ewm/widgets/TextFormFields/text_form_field_price.dart';
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
  final TextFormFieldPrice _textFormFieldPrice = TextFormFieldPrice();

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
                child: _textFormFieldPrice,
              ),
              TextButton(
                child: const Text(
                  'Fertig',
                  style: TextStyle(color: Colors.purple),
                ),
                onPressed: () {
                  debugPrint('edit price fertig bnutten was pressed');
                  if (_formKeyPriceInput.currentState!.validate()) {
                    debugPrint('submitData()');
                    updateItemPriceinSqliteDB(
                      itemId: itemId,
                      newItemPrice: _textFormFieldPrice.priceController.text,
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
