import 'package:flutter/material.dart';

class InputTextFormFieldPrice extends StatelessWidget {
  const InputTextFormFieldPrice({required this.priceController, Key? key})
      : super(key: key);
  final TextEditingController priceController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
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
    );
  }
}
