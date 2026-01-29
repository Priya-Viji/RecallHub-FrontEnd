import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ThemeEvent {}

class ToggleThemeEvent extends ThemeEvent {}

class ThemeBloc extends Bloc<ThemeEvent, ThemeMode> {
  ThemeBloc() : super(ThemeMode.light) {
    on<ToggleThemeEvent>((event, emit) {
      emit(state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light);
    });
  }
}
