import 'package:flutter/material.dart';

class AddNewItemCard extends StatelessWidget {
  AddNewItemCard({Key? key, required this.addItemFunction}) : super(key: key);
  final Function addItemFunction;
  final titleController = TextEditingController();
  final priceController = TextEditingController();
  final _formKeyTitleInput = GlobalKey<FormState>();
  final _formKeyPriceInput = GlobalKey<FormState>();

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
              Form(
                key: _formKeyPriceInput,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // InputTextFormFieldPrice(priceController: priceController),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Preis'),
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Bitte einen Preis eingeben!';
                        }
                        if (double.parse(value) > 999.99) {
                          return 'Bitte einen realen Artikelpreis eingeben!';
                        }

                        return null;
                      },
                    )
                  ],
                ),
              ),
              TextButton(
                child: const Text(
                  'Artikel hinzufügen',
                  style: TextStyle(color: Colors.purple),
                ),
                onPressed: () {
                  if (_formKeyTitleInput.currentState!.validate() &&
                      _formKeyPriceInput.currentState!.validate()) {
                    debugPrint('submitData()');
                    addItemFunction(['text1', 'text2']);
                    // [titleController.text, priceController.text]);
                  }
                  if (_formKeyTitleInput.currentState!.validate() &&
                      _formKeyPriceInput.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text('Artikel wurde zur Einkausliste hinzugefügt'),
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
