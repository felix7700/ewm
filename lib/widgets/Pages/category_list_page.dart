import 'package:ewm/widgets/Buttons/add_category_button.dart';
import 'package:flutter/material.dart';

class CategoryListPage extends StatelessWidget {
  const CategoryListPage({required this.categoryNames, Key? key})
      : super(key: key);
  final Set<dynamic> categoryNames;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Kategorieen',
            style: TextStyle(fontSize: 24),
          ),
        ),
        actions: const [
          AddCategoryButton(),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: categoryNames.length,
              itemBuilder: (context, int element) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Card(
                      color: Colors.blue.shade300,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 200.0,
                          child: Text(
                            categoryNames.elementAt(element),
                            style: const TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
