part of 'porfile_bloc.dart';

sealed class PorfileEvent extends Equatable {
  const PorfileEvent();

  @override
  List<Object> get props => [];
}

class SubmitChildForm extends PorfileEvent {
  final String childName;
  final String childAge;
  final String childIntersets;

  const SubmitChildForm({
    required this.childName,
    required this.childAge,
    required this.childIntersets,
  });

  @override
  List<Object> get props => [childName, childAge, childIntersets];
}

class UpdateChildForm extends PorfileEvent {
  final String childId;
  final String childName;
  final String childAge;
  final String childIntersets;

  const UpdateChildForm({
    required this.childId,
    required this.childName,
    required this.childAge,
    required this.childIntersets,
  });

  @override
  List<Object> get props => [childId, childName, childAge, childIntersets];
}

class LoadChildren extends PorfileEvent {
  const LoadChildren();
}

class DeleteChild extends PorfileEvent {
  final String childId;

  const DeleteChild(this.childId);

  @override
  List<Object> get props => [childId];
}

class LogoutRequested extends PorfileEvent {
  const LogoutRequested();
}

class PopulateChildForm extends PorfileEvent {
  final ChildEntity child;

  const PopulateChildForm(this.child);

  @override
  List<Object> get props => [child];
}

class ResetForm extends PorfileEvent {
  const ResetForm();
}
  