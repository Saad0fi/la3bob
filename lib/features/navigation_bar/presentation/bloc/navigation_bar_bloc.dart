import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:la3bob/features/navigation_bar/presentation/screens/home_screen.dart';
import 'package:la3bob/features/navigation_bar/presentation/screens/setting_screen.dart';

part 'navigation_bar_event.dart';
part 'navigation_bar_state.dart';

class NavigationBarBloc extends Bloc<NavigationBarEvent, NavigationBarState> {
  int currentIndex = 0;
  List<Widget> screens = [SettingScreen(), HomeScreen()];
  NavigationBarBloc() : super(NavigationBarInitial()) {
    on<NavigationBarEvent>((event, emit) {});
    on<NavigationBarTapEvent>((event, emit) {
      emit(NavigationBarInitial());
      currentIndex = event.index;
      emit(NavigationBarStateChange());
    });
  }
}
