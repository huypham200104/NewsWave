import 'package:freezed_annotation/freezed_annotation.dart';

part 'news_source_entity.freezed.dart';

@freezed
class NewsSourceEntity with _$NewsSourceEntity {
  const factory NewsSourceEntity({
    required String id,
    required String name,
    required String description,
    required String url,
    required String category,
  }) = _NewsSourceEntity;
}
