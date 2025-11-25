import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'porfile_event.dart';
part 'porfile_state.dart';

class PorfileBloc extends Bloc<PorfileEvent, PorfileState> {
  PorfileBloc() : super(PorfileInitial()) {
    on<PorfileEvent>((event, emit) {});
  }
}
