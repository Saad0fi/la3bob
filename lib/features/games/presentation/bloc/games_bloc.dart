import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:la3bob/audio/audio_controller.dart';

part 'games_event.dart';
part 'games_state.dart';

class GamesBloc extends Bloc<GamesEvent, GamesState> {
  final audioController = AudioController();

  GamesBloc() : super(GamesInitial()) {
    on<GamesEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
  initAudio() async {
    await audioController.initialize();
  }
}
