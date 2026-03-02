import 'package:equatable/equatable.dart';

abstract class DiscoverEvent extends Equatable {
  const DiscoverEvent();

  @override
  List<Object?> get props => [];
}

class LoadDiscoverDataEvent extends DiscoverEvent {}

class ClearSearchHistoryEvent extends DiscoverEvent {}

class SearchDiscoverEvent extends DiscoverEvent {
  final String query;
  final String? sortBy;
  final String? from;
  final String? to;

  const SearchDiscoverEvent({
    required this.query,
    this.sortBy,
    this.from,
    this.to,
  });

  @override
  List<Object?> get props => [query, sortBy, from, to];
}
