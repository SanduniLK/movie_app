import 'package:flutter/material.dart';
import '../utils/colors.dart';

class SidebarWidget extends StatelessWidget {
  final Function(String, String) onFilterSelected;
  final bool isDarkMode;
  final Function(bool) onThemeToggle;
  final String selectedRating;
  final String selectedYear;

  const SidebarWidget({
    super.key,
    required this.onFilterSelected,
    required this.isDarkMode,
    required this.onThemeToggle,
    required this.selectedRating,
    required this.selectedYear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.getSurfaceColor(isDarkMode),
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 30),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: AppColors.appBarGradient,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Icon(
                            Icons.movie_filter,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "FILTERS",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Sort by Year & Rating",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // Close button
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                
                // Theme Toggle
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            isDarkMode ? Icons.dark_mode : Icons.light_mode,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            isDarkMode ? "Dark Mode" : "Light Mode",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      Switch(
                        value: isDarkMode,
                        onChanged: (value) {
                          onThemeToggle(value);
                        },
                        activeColor: Colors.white,
                        activeTrackColor: Colors.black,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Filter Options
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // IMDb Rating Section
                _buildFilterSection(
                  title: "IMDb Rating",
                  icon: Icons.star,
                  options: const ['All', '9+', '8+', '7+', '6+', '5+', 'Below 5'],
                  selectedValue: selectedRating,
                  onSelected: (value) {
                    onFilterSelected('rating', value);
                    Navigator.pop(context);
                  },
                ),
                
                const SizedBox(height: 20),
                
                // Release Year Section
                _buildFilterSection(
                  title: "Release Year",
                  icon: Icons.calendar_today,
                  options: const [
                    'All', '2024', '2023', '2022', '2021', '2020',
                    '2010-2019', '2000-2009', '1990-1999', 'Older'
                  ],
                  selectedValue: selectedYear,
                  onSelected: (value) {
                    onFilterSelected('year', value);
                    Navigator.pop(context);
                  },
                ),

                const SizedBox(height: 30),

                // Reset Button
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      onFilterSelected('reset', '');
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryRed,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text("Reset All Filters"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection({
    required String title,
    required IconData icon,
    required List<String> options,
    required String selectedValue,
    required Function(String) onSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.primaryRed, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: AppColors.getTextColor(isDarkMode),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final isSelected = selectedValue == option;
            return InkWell(
              onTap: () => onSelected(option),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryRed
                      : (isDarkMode 
                          ? Colors.grey.shade800.withValues(alpha: 0.5)
                          : Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? Colors.transparent
                        : AppColors.getBorderColor(isDarkMode).withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  option,
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : AppColors.getTextColor(isDarkMode),
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}