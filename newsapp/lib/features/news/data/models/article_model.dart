import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/article_entity.dart';

part 'article_model.freezed.dart';
part 'article_model.g.dart';

@freezed
class ArticleModel with _$ArticleModel {
  const ArticleModel._();

  @JsonSerializable(explicitToJson: true)
  const factory ArticleModel({
    String? author,
    String? title,
    String? description,
    String? url,
    String? urlToImage,
    String? publishedAt,
    String? content,
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