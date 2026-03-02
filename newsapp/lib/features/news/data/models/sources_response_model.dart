import 'news_source_model.dart';

class SourcesResponseModel {
  final String status;
  final List<NewsSourceModel> sources;

  SourcesResponseModel({
    required this.status,
    required this.sources,
  });

  factory SourcesResponseModel.fromJson(Map<String, dynamic> json) {
    return SourcesResponseModel(
      status: json['status'] ?? '',
      sources: (json['sources'] as List?)
              ?.map((source) => NewsSourceModel.fromJson(source))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'sources': sources.map((source) => source.toJson()).toList(),
    };
  }
}
