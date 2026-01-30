import 'package:flutter/material.dart';

class SearchFriendsBar extends StatelessWidget {
  final VoidCallback? onSearchTap;
  final VoidCallback? onAddFriendTap;
  final TextEditingController? controller;

  const SearchFriendsBar({
    super.key,
    this.onSearchTap,
    this.onAddFriendTap,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Search Bar Container (White Pill with Search Button inside)
        Expanded(
          child: Container(
            height: 54,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(100),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08), // Soft shadow
                  blurRadius: 15,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(5), // Padding for inner elements
            child: Row(
              children: [
                // Inner Left Black Search Button
                GestureDetector(
                  onTap: onSearchTap,
                  child: Container(
                    width: 46,
                    height: 46,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Text Input
                Expanded(
                  child: TextField(
                    controller: controller,
                    // textAlignVertical: TextAlignVertical.center,
                    decoration: const InputDecoration(
                      hintText: 'Search friends',
                      hintStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        fontFamily: 'Inika',
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      filled: true,
                      fillColor: Colors.transparent,
                    ),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Inika',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ),

        const SizedBox(width: 12),

        // Separate Right Black Add Friend Button
        GestureDetector(
          onTap: onAddFriendTap,
          child: Container(
            width: 54, // Same height as valid search bar
            height: 54,
            decoration: BoxDecoration(
              color: const Color(
                0xFF1E1E1E,
              ), // Slightly softer black or pure black
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            // Using a Stack or custom icon to match "User with plus" strictly if needed,
            // but person_add is closest standard icon.
            // The image shows a user outline with a plus.
            child: const Icon(
              Icons.person_add_alt_1, // Outline style person with plus
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
      ],
    );
  }
}
