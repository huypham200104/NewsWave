import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/user_profile.dart';

abstract class ProfileLocalDataSource {
  Future<UserProfile> getUserProfile();
  Future<void> cacheUserProfile(UserProfile profile);
}

const cachedUserName = 'user_name';
const cachedUserTopics = 'user_topics';

@LazySingleton(as: ProfileLocalDataSource)
class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  final SharedPreferences sharedPreferences;

  ProfileLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<UserProfile> getUserProfile() async {
    final userName = sharedPreferences.getString(cachedUserName) ?? 'Reader';
    final topics = sharedPreferences.getStringList(cachedUserTopics) ?? [];
    return UserProfile(userName: userName, topics: topics);
  }

  @override
  Future<void> cacheUserProfile(UserProfile profile) async {
    await sharedPreferences.setString(cachedUserName, profile.userName);
    await sharedPreferences.setStringList(cachedUserTopics, profile.topics);
  }
}
