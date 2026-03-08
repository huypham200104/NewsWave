import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ProfileAvatarSection extends StatelessWidget {
  final String userName;

  const ProfileAvatarSection({
    super.key,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: primaryColor.withAlpha(50),
          child: Text(
            userName.isNotEmpty ? userName[0].toUpperCase() : 'R',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: primaryColor,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.edit, color: Colors.white, size: 20),
        )
      ],
    ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack);
  }
}
