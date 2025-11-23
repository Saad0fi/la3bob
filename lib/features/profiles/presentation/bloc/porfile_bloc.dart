import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'porfile_event.dart';
part 'porfile_state.dart';

class PorfileBloc extends Bloc<PorfileEvent, PorfileState> {
  PorfileBloc() : super(PorfileInitial()) {
    on<PorfileEvent>((event, emit) {});
  }
}
