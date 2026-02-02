import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart'; // Bổ sung Hive
import '../../domain/entities/article_entity.dart';

part 'article_model.freezed.dart';
part 'article_model.g.dart';

@freezed
@HiveType(typeId: 0) // Cần khai báo TypeId cho Hive (Giai đoạn 2)
class ArticleModel with _$ArticleModel {
  const ArticleModel._();

  const factory ArticleModel({
    @HiveField(0) String? author,
    @HiveField(1) String? title,
    @HiveField(2) String? description,
    @HiveField(3) String? url,
    @HiveField(4) String? urlToImage,
    @HiveField(5) String? publishedAt,
    @HiveField(6) String? content,
    // SourceModel không nên lưu vào Hive nếu không thực sự cần thiết, 
    // hoặc phải tạo Adapter riêng cho nó.
    SourceModel? source, 
  }) = _ArticleModel;

  factory ArticleModel.fromJson(Map<String, dynamic> json) =>
      _$ArticleModelFromJson(json);

  // Mapper chuyển đổi sang Entity cho Domain Layer
  ArticleEntity toEntity() {
    return ArticleEntity(
      author: author ?? 'Unknown Author',
      title: title ?? 'No Title',
      description: description ?? 'No Description',
      url: url ?? '',
      urlToImage: urlToImage ?? '',
      publishedAt: DateTime.tryParse(publishedAt ?? '') ?? DateTime.now(),
      content: content ?? '',
    );
  }
}

@freezed
class SourceModel with _$SourceModel {
  const factory SourceModel({
    String? id,
    String? name,
  }) = _SourceModel;

  factory SourceModel.fromJson(Map<String, dynamic> json) =>
      _$SourceModelFromJson(json);
}