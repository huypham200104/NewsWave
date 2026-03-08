import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
import '../../domain/entities/user_profile.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  List<String> _topics = [];

  final List<String> _availableTopics = [
    'Technology', 'Business', 'Sports', 'Science', 
    'Health', 'Entertainment', 'Politics', 'Art'
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    final profileState = context.read<ProfileBloc>().state;
    if (profileState is ProfileLoaded) {
      _nameController.text = profileState.profile.userName;
      _topics = List.from(profileState.profile.topics);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _toggleTopic(String topic) {
    setState(() {
      if (_topics.contains(topic)) {
        _topics.remove(topic);
      } else {
        _topics.add(topic);
      }
    });
  }

  void _saveProfile() {
    final updatedProfile = UserProfile(
      userName: _nameController.text.trim().isEmpty ? 'Reader' : _nameController.text.trim(),
      topics: _topics,
    );
    context.read<ProfileBloc>().add(UpdateProfile(updatedProfile));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveProfile,
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Username',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Enter your name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Your Interests',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _availableTopics.map((topic) {
                final isSelected = _topics.contains(topic);
                final theme = Theme.of(context);
                return ActionChip(
                  label: Text(topic),
                  backgroundColor: isSelected ? theme.primaryColor : Colors.transparent,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : theme.textTheme.bodyLarge?.color,
                  ),
                  side: BorderSide(
                    color: isSelected ? theme.primaryColor : Colors.grey.shade400,
                  ),
                  onPressed: () => _toggleTopic(topic),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
