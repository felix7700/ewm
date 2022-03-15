import 'package:flutter/material.dart';

class FormFieldPrice extends StatelessWidget {
  FormFieldPrice({Key? key}) : super(key: key);

  final TextEditingController priceController = TextEditingController();
  final GlobalKey<FormState> formKeyPriceInput = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKeyPriceInput,
      child: TextFormField(
        autofocus: true,
        decoration: const InputDecoration(labelText: 'Preis'),
        controller: priceController,
        keyboardType: TextInputType.datetime,
        validator: (String? value) {
          if (value!.isEmpty) {
            return 'Bitte einen Preis eingeben!';
          }
          value = value.replaceAll(r",", ".");
          try {
            if (double.parse(value) > 999.99) {
              return 'Bitte einen realen Artikelpreis eingeben!';
            }
            double d = double.parse(value);
            String inString = d.toStringAsFixed(2);
            value = inString;
            priceController.text = value.toString();
            return null;
          } catch (error) {
            return 'Bitte einen Preis eingeben!';
          }
        },
      ),
    );
  }
}
