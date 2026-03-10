import 'package:flutter/material.dart';

import '../utils/colors.dart';

class MovieSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onClear;
  final Function(String) onSearch;
  final bool isDarkMode;

  const MovieSearchBar({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onClear,
    required this.onSearch,
    required this.isDarkMode,
  });

  @override
  State<MovieSearchBar> createState() => _MovieSearchBarState();
}

class _MovieSearchBarState extends State<MovieSearchBar> {
  @override
  Widget build(BuildContext context) {
    final accentColor = AppColors.primaryRed;
    final textColor = AppColors.getTextColor(widget.isDarkMode);
    final secondaryTextColor = AppColors.getSecondaryTextColor(widget.isDarkMode);
    final inputColor = AppColors.getInputColor(widget.isDarkMode);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        style: TextStyle(
          color: textColor,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          hintText: 'Search movies...',
          hintStyle: TextStyle(
            color: secondaryTextColor,
          ),
          filled: true,
          fillColor: inputColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: accentColor,
          ),
          suffixIcon: widget.controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: secondaryTextColor,
                  ),
                  onPressed: () {
                    widget.onClear();
                    widget.onSearch('');
                  },
                )
              : null,
        ),
        onChanged: (value) {
          // You can add debounce here if needed
          setState(() {}); // To update suffix icon
        },
        onSubmitted: (value) {
          if (value.trim().isNotEmpty) {
            widget.onSearch(value);
          }
        },
      ),
    );
  }
}