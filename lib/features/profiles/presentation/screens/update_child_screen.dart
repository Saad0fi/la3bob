import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:la3bob/core/di/injection.dart';
import 'package:la3bob/features/auth/domain/usecases/auth_use_cases.dart';
import 'package:la3bob/features/profiles/domain/entities/child_entity.dart';
import 'package:la3bob/features/profiles/domain/usecase/profile_usecase.dart';
import 'package:la3bob/features/profiles/presentation/bloc/porfile_bloc.dart';
import 'package:la3bob/features/profiles/presentation/widgets/interests_selector.dart';

class UpdateChildScreen extends StatelessWidget {
  final ChildEntity child;

  const UpdateChildScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final Set<String> selectedInterests = {...child.intersets};

    return BlocProvider(
      create: (_) =>
          PorfileBloc(getIt<ProfileUsecase>(), getIt<AuthUseCases>())
            ..add(PopulateChildForm(child)),
      child: Scaffold(
        appBar: AppBar(title: const Text('تعديل بيانات الطفل')),
        body: BlocListener<PorfileBloc, PorfileState>(
          listener: (context, state) {
            if (state is PorfileSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
              context.pop(true);
            } else if (state is PorfileError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.failure.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: BlocBuilder<PorfileBloc, PorfileState>(
            builder: (context, state) {
              final bloc = context.read<PorfileBloc>();

              if (state is PorfileLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              return SingleChildScrollView(
                padding: const .all(16.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: .stretch,
                    children: [
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: bloc.nameController,
                        enabled: state is! PorfileLoading,
                        decoration: const InputDecoration(
                          labelText: 'اسم الطفل',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        textDirection: TextDirection.rtl,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'الرجاء إدخال اسم الطفل';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: bloc.ageController,
                        enabled: state is! PorfileLoading,
                        decoration: const InputDecoration(
                          labelText: 'عمر الطفل',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.cake_outlined),
                        ),
                        keyboardType: TextInputType.number,
                        textDirection: TextDirection.rtl,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'الرجاء إدخال عمر الطفل';
                          }
                          final age = int.tryParse(value);
                          if (age == null || age < 3 || age > 12) {
                            return 'الرجاء إدخال عمر صحيح (من 3 إلى 12)';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      InterestsSelector(
                        selectedInterests: selectedInterests,
                        onChanged: (interests) {
                          selectedInterests
                            ..clear()
                            ..addAll(interests);
                        },
                      ),

                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: state is PorfileLoading
                            ? null
                            : () {
                                if (formKey.currentState!.validate()) {
                                  if (selectedInterests.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'الرجاء اختيار اهتمام واحد على الأقل',
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                    return;
                                  }

                                  bloc.intersetsController.text =
                                      selectedInterests.join(', ');

                                  bloc.add(
                                    UpdateChildForm(
                                      childId: child.id,
                                      childName: bloc.nameController.text
                                          .trim(),
                                      childAge: bloc.ageController.text.trim(),
                                      childIntersets: bloc
                                          .intersetsController
                                          .text
                                          .trim(),
                                    ),
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          padding: const .only(top: 16, bottom: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: .circular(8),
                          ),
                        ),
                        child: const Text(
                          'حفظ التعديلات',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
