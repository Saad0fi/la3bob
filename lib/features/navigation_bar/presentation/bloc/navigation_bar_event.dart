part of 'navigation_bar_bloc.dart';

@immutable
sealed class NavigationBarEvent {}

class NavigationBarTapEvent extends NavigationBarEvent {
  final int index;

  NavigationBarTapEvent(this.index);
}