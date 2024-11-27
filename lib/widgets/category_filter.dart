import 'package:flutter/material.dart';

class CategoryFilter extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const CategoryFilter({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: categories.map((category) {
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ChoiceChip(
                label: Text(category),
                selected: selectedCategory == category,
                onSelected: (selected) {
                  if (selected) {
                    onCategorySelected(category);
                  }
                },
                selectedColor: Colors.blue,
                labelStyle: TextStyle(
                  color: selectedCategory == category
                    ? Colors.white
                    : Colors.black,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}