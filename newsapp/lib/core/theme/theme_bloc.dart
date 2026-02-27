import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

enum ThemeEvent { toggle }

@injectable
class ThemeBloc extends Bloc<ThemeEvent, ThemeMode> {
  ThemeBloc() : super(ThemeMode.light) {
    on<ThemeEvent>((event, emit) {
      if (state == ThemeMode.light) {
        emit(ThemeMode.dark);
      } else {
        emit(ThemeMode.light);
      }
    });
  }
}
