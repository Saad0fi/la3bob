part of 'porfile_bloc.dart';

@immutable
sealed class PorfileState {}

final class PorfileInitial extends PorfileState {}

final class PorfileChildrenLoading extends PorfileState {}

final class PorfileChildrenLoaded extends PorfileState {
  final List<ChildEntity> children;
  final bool isChildLockModeActive;

  PorfileChildrenLoaded(this.children, {this.isChildLockModeActive = false});

  PorfileChildrenLoaded copyWith({
    List<ChildEntity>? children,
    bool? isChildLockModeActive,
  }) {
    return PorfileChildrenLoaded(
      children ?? this.children,
      isChildLockModeActive:
          isChildLockModeActive ?? this.isChildLockModeActive,
    );
  }
}

final class PorfileForm extends PorfileState {
  final String childName;
  final String childAge;
  final String childIntersets;

  PorfileForm({
    this.childName = '',
    this.childAge = '',
    this.childIntersets = '',
  });
}

final class PorfileLoading extends PorfileState {}

final class PorfileSuccess extends PorfileState {
  final String message;
  PorfileSuccess(this.message);
}

final class PorfileError extends PorfileState {
  final ProfilesFailure failure;
  PorfileError(this.failure);
}
