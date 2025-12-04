import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:la3bob/core/di/injection.dart';
import 'package:la3bob/features/auth/domain/usecases/auth_use_cases.dart';
import 'package:la3bob/features/profiles/domain/usecase/profile_usecase.dart';
import 'package:la3bob/features/profiles/presentation/bloc/porfile_bloc.dart';

class AddChildScreen extends StatelessWidget {
  const AddChildScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return BlocProvider(
      create: (context) =>
          PorfileBloc(getIt<ProfileUsecase>(), getIt<AuthUseCases>()),
      child: Scaffold(
        appBar: AppBar(title: const Text('إضافة طفل')),
        body: BlocListener<PorfileBloc, PorfileState>(
          listener: (context, state) {
            if (state is PorfileLoading) {
              Navigator.of(context).pop(true);
            } else if (state is PorfileSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
            } else if (state is PorfileError) {
              Navigator.of(context).pop();
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
              final isLoading = state is PorfileLoading;

              if (isLoading) {
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
                        enabled: !isLoading,
                        decoration: const InputDecoration(
                          labelText: 'اسم الطفل',
                          hintText: 'أدخل اسم الطفل',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
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
                        enabled: !isLoading,
                        decoration: const InputDecoration(
                          labelText: 'عمر الطفل',
                          hintText: 'أدخل عمر الطفل',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.cake),
                        ),
                        keyboardType: TextInputType.number,
                        textDirection: TextDirection.rtl,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'الرجاء إدخال عمر الطفل';
                          }
                          final age = int.tryParse(value);
                          if (age == null || age < 1 || age > 13) {
                            return 'الرجاء إدخال عمر صحيح (من 1 إلى 18)';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: bloc.intersetsController,
                        enabled: !isLoading,
                        decoration: const InputDecoration(
                          labelText: 'اهتمامات الطفل',
                          hintText:
                              'أدخل اهتمامات الطفل (مثل: الرسم، القراءة، الرياضة...)',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.favorite),
                          alignLabelWithHint: true,
                        ),
                        maxLines: 4,
                        textDirection: TextDirection.rtl,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'الرجاء إدخال اهتمامات الطفل';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () {
                                if (formKey.currentState!.validate()) {
                                  bloc.add(
                                    SubmitChildForm(
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
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'إضافة الطفل',
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
