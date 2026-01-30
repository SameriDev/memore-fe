import 'package:flutter/material.dart';
import '../../widgets/decorated_background.dart';

class AddFriendScreen extends StatelessWidget {
  const AddFriendScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBackground(
      child: Column(
        children: [
          AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text('Add Friend', style: TextStyle(color: Colors.black)),
          ),
          const Expanded(
            child: Center(
              child: Text(
                'Add Friend Screen\n(Coming soon)',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
