import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final String currentCity;
  final Function(String) onSearch;
  final VoidCallback onReturnToDefault;

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.currentCity,
    required this.onSearch,
    required this.onReturnToDefault,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: 'Rechercher une ville...',
                  border: InputBorder.none,
                  icon: Icon(Icons.search, color: Colors.blue),
                ),
                onSubmitted: onSearch,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.my_location, color: Colors.blue),
              onPressed: onReturnToDefault,
              tooltip: 'Retour à la ville par défaut ($currentCity)',
            ),
          ],
        ),
      ),
    );
  }
}