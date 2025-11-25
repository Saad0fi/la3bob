import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:la3bob/features/profiles/presentation/bloc/porfile_bloc.dart';

class AddChildScreen extends StatelessWidget {
  const AddChildScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PorfileBloc(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            body: Column(
              children: [
                Center(
                  child: ElevatedButton(onPressed: () {}, child: Text("data")),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
