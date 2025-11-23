import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:la3bob/features/profiles/data/datasource/profiles_datasource.dart';
import 'package:la3bob/features/profiles/data/repositories/profiles_repository.dart';
import 'package:la3bob/features/profiles/presentation/bloc/porfile_bloc.dart';

class AddChildScreen extends StatelessWidget {
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
