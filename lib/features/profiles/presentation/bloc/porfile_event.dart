part of 'porfile_bloc.dart';

sealed class PorfileEvent extends Equatable {
  const PorfileEvent();

  @override
  List<Object> get props => [];
}

class SubmitChildForm extends PorfileEvent {
  final String childName;
  final String childAge;
  final String childInterests;

  const SubmitChildForm({
    required this.childName,
    required this.childAge,
    required this.childInterests,
  });

  @override
  List<Object> get props => [childName, childAge, childInterests];
}

class ResetForm extends PorfileEvent {
  const ResetForm();
}
  