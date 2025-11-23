part of 'porfile_bloc.dart';

sealed class PorfileState extends Equatable {
  const PorfileState();
  
  @override
  List<Object> get props => [];
}

final class PorfileInitial extends PorfileState {}
