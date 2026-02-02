// Lỗi từ Server (API trả về khác 200, format sai...)
class ServerException implements Exception {}

// Lỗi về Mạng (Timeout, không có internet...)
class NetworkException implements Exception {}

// Lỗi từ Local Database (Hive box chưa mở, lỗi ghi...)
class CacheException implements Exception {}

// Lỗi từ Database (Nếu sau này dùng SQLite/Drift)
class DatabaseException implements Exception {}

// Lỗi xác thực (Token hết hạn, 401...)
class AuthenticationException implements Exception {}

// Lỗi dữ liệu đầu vào không hợp lệ
class ValidationException implements Exception {}