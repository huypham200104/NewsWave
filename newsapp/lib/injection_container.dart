import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'injection_container.config.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
Future<void> configureDependencies() async {
  // 1. Init Hive
  await Hive.initFlutter();
  
  // 2. Register SharedPreferences manually (external dependency)
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPreferences);
  
  // 3. Auto-generated dependency injection
  // All @injectable/@lazySingleton annotated classes will be registered
  getIt.init();
}