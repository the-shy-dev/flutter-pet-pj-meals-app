import 'package:flutter/material.dart';
import 'package:meals/models/meal.dart';
import 'package:meals/data/dummy_data.dart';
import 'package:meals/models/category.dart';

class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({super.key, required this.onAddRecipe});

  final void Function(Meal meal) onAddRecipe;

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _titleController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final List<String> _ingredients = [];
  final List<String> _steps = [];
  String? _ingredientInput;
  String? _stepInput;
  String? _selectedCategoryId;
  final _newCategoryController = TextEditingController();
  bool _showNewCategoryField = false;

  void _addIngredient() {
    if (_ingredientInput != null && _ingredientInput!.trim().isNotEmpty) {
      setState(() {
        _ingredients.add(_ingredientInput!.trim());
        _ingredientInput = '';
      });
    }
  }

  void _addStep() {
    if (_stepInput != null && _stepInput!.trim().isNotEmpty) {
      setState(() {
        _steps.add(_stepInput!.trim());
        _stepInput = '';
      });
    }
  }

  void _submit() {
    if (_titleController.text.trim().isEmpty ||
        _ingredients.isEmpty ||
        _steps.isEmpty ||
        (_selectedCategoryId == null &&
            _newCategoryController.text.trim().isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields.')),
      );
      return;
    }
    String imageUrl = _imageUrlController.text.trim();
    if (imageUrl.isEmpty) {
      imageUrl = 'https://via.placeholder.com/400x300?text=No+Image';
    }
    String categoryId = _selectedCategoryId ?? '';
    if (categoryId.isEmpty) {
      // Create new category
      categoryId = 'user_${DateTime.now().millisecondsSinceEpoch}';
      availableCategories.add(Category(
        id: categoryId,
        title: _newCategoryController.text.trim(),
        color: Colors.grey,
      ));
    }
    final meal = Meal(
      id: DateTime.now().toString(),
      categories: [categoryId],
      title: _titleController.text.trim(),
      imageUrl: imageUrl,
      ingredients: List.from(_ingredients),
      steps: List.from(_steps),
      duration: 30,
      complexity: Complexity.simple,
      affordability: Affordability.affordable,
      isGlutenFree: false,
      isLactoseFree: false,
      isVegan: false,
      isVegetarian: false,
    );
    widget.onAddRecipe(meal);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Recipe')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _imageUrlController,
                decoration: const InputDecoration(labelText: 'Image URL'),
              ),
              const SizedBox(height: 12),
              // Show image preview or placeholder
              Center(
                child: Container(
                  width: 200,
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                  child: _imageUrlController.text.trim().isEmpty
                      ? Image.network(
                          'https://via.placeholder.com/400x300?text=No+Image',
                          fit: BoxFit.cover)
                      : Image.network(_imageUrlController.text.trim(),
                          fit: BoxFit.cover,
                          errorBuilder: (ctx, err, stack) => Image.network(
                              'https://via.placeholder.com/400x300?text=No+Image',
                              fit: BoxFit.cover)),
                ),
              ),
              const SizedBox(height: 24),
              Text('Category', style: Theme.of(context).textTheme.titleLarge),
              Row(
                children: [
                  Expanded(
                    child: DropdownButton<String>(
                      value: _selectedCategoryId,
                      hint: const Text('Select category'),
                      isExpanded: true,
                      items: [
                        ...availableCategories.map((cat) => DropdownMenuItem(
                              value: cat.id,
                              child: Text(cat.title),
                            )),
                      ],
                      onChanged: (val) {
                        setState(() {
                          _selectedCategoryId = val;
                          _showNewCategoryField = false;
                        });
                      },
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _showNewCategoryField = !_showNewCategoryField;
                        _selectedCategoryId = null;
                      });
                    },
                    child: Text(_showNewCategoryField ? 'Cancel' : 'Add New'),
                  ),
                ],
              ),
              if (_showNewCategoryField)
                TextField(
                  controller: _newCategoryController,
                  decoration: const InputDecoration(labelText: 'New Category'),
                ),
              const SizedBox(height: 24),
              Text('Ingredients',
                  style: Theme.of(context).textTheme.titleLarge),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (val) => _ingredientInput = val,
                      decoration:
                          const InputDecoration(hintText: 'Add ingredient'),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _addIngredient,
                  ),
                ],
              ),
              ..._ingredients.map((ing) => ListTile(title: Text(ing))).toList(),
              const SizedBox(height: 24),
              Text('Steps', style: Theme.of(context).textTheme.titleLarge),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (val) => _stepInput = val,
                      decoration: const InputDecoration(hintText: 'Add step'),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _addStep,
                  ),
                ],
              ),
              ..._steps.map((step) => ListTile(title: Text(step))).toList(),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: _submit,
                  child: const Text('Add Recipe'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
