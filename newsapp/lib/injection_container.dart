import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'injection_container.config.dart'; // File này sẽ được sinh ra sau

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init', // Tên hàm khởi tạo mặc định
  preferRelativeImports: true, // Sử dụng relative import cho file sinh ra
  asExtension: true, // Dùng extension method
)
Future<void> configureDependencies() async {
  // 1. Init Hive trước khi inject các module khác
  await Hive.initFlutter();
  // Tại đây bạn có thể mở các Box nếu cần thiết ngay lúc khởi động
  // await Hive.openBox('newsBox'); 
  
  // 2. Khởi tạo dependency tree
  getIt.init();
}