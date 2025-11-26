part of 'porfile_bloc.dart';

@immutable
sealed class PorfileState {}

final class PorfileInitial extends PorfileState {}

final class PorfileForm extends PorfileState {
  final String childName;
  final String childAge;
  final String childInterests;

  PorfileForm({
    this.childName = '',
    this.childAge = '',
    this.childInterests = '',
  });
}

final class PorfileLoading extends PorfileState {}


final class PorfileSuccess extends PorfileState {
  final String message;
  PorfileSuccess(this.message);
}


final class PorfileError extends PorfileState {
  final String error;
  PorfileError(this.error);
}



