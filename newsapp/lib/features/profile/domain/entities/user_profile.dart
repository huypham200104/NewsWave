import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  final String userName;
  final List<String> topics;

  const UserProfile({
    required this.userName,
    required this.topics,
  });

  UserProfile copyWith({
    String? userName,
    List<String>? topics,
  }) {
    return UserProfile(
      userName: userName ?? this.userName,
      topics: topics ?? this.topics,
    );
  }

  @override
  List<Object?> get props => [userName, topics];
}
