part of 'porfile_bloc.dart';

@immutable
sealed class PorfileState {}

final class PorfileInitial extends PorfileState {
  const PorfileInitial();
}

final class PorfileForm extends PorfileState {
  final String childName;
  final String childAge;
  final String childInterests;

  const PorfileForm({
    this.childName = '',
    this.childAge = '',
    this.childInterests = '',
  });
}

final class PorfileLoading extends PorfileState {
  const PorfileLoading();
}


final class PorfileSuccess extends PorfileState {
  final String message;
  const PorfileSuccess(this.message);
}


final class PorfileError extends PorfileState {
  final String error;
  const PorfileError(this.error);
}



