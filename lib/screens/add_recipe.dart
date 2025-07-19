import 'package:flutter/material.dart';
import 'package:meals/models/meal.dart';

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
        _imageUrlController.text.trim().isEmpty ||
        _ingredients.isEmpty ||
        _steps.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields.')),
      );
      return;
    }
    final meal = Meal(
      id: DateTime.now().toString(),
      categories: [],
      title: _titleController.text.trim(),
      imageUrl: _imageUrlController.text.trim(),
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
