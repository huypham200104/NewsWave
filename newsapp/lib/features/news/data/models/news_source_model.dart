import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/news_source_entity.dart';

part 'news_source_model.freezed.dart';
part 'news_source_model.g.dart';

@freezed
class NewsSourceModel with _$NewsSourceModel {
  const NewsSourceModel._();

  const factory NewsSourceModel({
    String? id,
    String? name,
    String? description,
    String? url,
    String? category,
  }) = _NewsSourceModel;

  factory NewsSourceModel.fromJson(Map<String, dynamic> json) =>
      _$NewsSourceModelFromJson(json);

  NewsSourceEntity toEntity() {
    return NewsSourceEntity(
      id: id ?? '',
      name: name ?? 'Unknown',
      description: description ?? '',
      url: url ?? '',
      category: category ?? '',
    );
  }
}
