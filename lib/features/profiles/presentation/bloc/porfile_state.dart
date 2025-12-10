part of 'porfile_bloc.dart';

@immutable
sealed class PorfileState {}

enum AccessStatus { initial, loading, granted, denied }

final class PorfileInitial extends PorfileState {}

final class PorfileChildrenLoading extends PorfileState {}

final class PorfileChildrenLoaded extends PorfileState {
  final List<ChildEntity> children;
  final bool isChildLockModeActive;
  final String? selectedChildId;
  final bool isSettingsProtected;
  final AccessStatus accessStatus;
  final String? accessErrorMessage;
  final String? currentParentId;

  PorfileChildrenLoaded(
    this.children, {
    this.isChildLockModeActive = false,
    this.selectedChildId,
    this.isSettingsProtected = false,
    this.accessStatus = AccessStatus.initial,
    this.accessErrorMessage,
    this.currentParentId,
  });

  PorfileChildrenLoaded copyWith({
    List<ChildEntity>? children,
    bool? isChildLockModeActive,
    String? selectedChildId,
    bool? isSettingsProtected,
    AccessStatus? accessStatus,
    String? accessErrorMessage,
    String? currentParentId,
  }) {
    return PorfileChildrenLoaded(
      children ?? this.children,
      isChildLockModeActive:
          isChildLockModeActive ?? this.isChildLockModeActive,
      selectedChildId: selectedChildId ?? this.selectedChildId,
      isSettingsProtected: isSettingsProtected ?? this.isSettingsProtected,
      accessStatus: accessStatus ?? this.accessStatus,
      accessErrorMessage: accessErrorMessage,
      currentParentId: currentParentId ?? this.currentParentId,
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

final class PorfileChildSelected extends PorfileState {
  final ChildEntity selectedChild;
  PorfileChildSelected(this.selectedChild);
}
