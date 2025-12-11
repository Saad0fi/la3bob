import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:la3bob/core/comon/helper_function/toast_helper.dart';
import 'package:la3bob/core/di/injection.dart';
import 'package:la3bob/features/auth/domain/usecases/auth_use_cases.dart';
import 'package:la3bob/features/navigation_bar/presentation/screens/navigation_bar.dart';
import 'package:la3bob/features/profiles/domain/usecase/profile_usecase.dart';
import 'package:la3bob/features/profiles/presentation/bloc/porfile_bloc.dart';
import 'package:la3bob/features/profiles/presentation/widgets/interests_selector.dart';

class AddChildScreen extends StatelessWidget {
  const AddChildScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final Set<String> selectedInterests = <String>{};

    return BlocProvider(
      create: (context) =>
          PorfileBloc(getIt<ProfileUsecase>(), getIt<AuthUseCases>()),
      child: Scaffold(
        appBar: AppBar(title: const Text('إضافة طفل')),
        body: BlocListener<PorfileBloc, PorfileState>(
          listener: (context, state) {
            if (state is PorfileSuccess) {
              showAppToast(message: state.message, type: ToastType.success);

              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop(true);
              } else {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (_) => const NavigationBarScreen(),
                  ),
                  (route) => false,
                );
              }
            } else if (state is PorfileError) {
              showAppToast(
                message: state.failure.message,
                type: ToastType.failure,
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
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
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
                        onPressed: isLoading
                            ? null
                            : () {
                                if (formKey.currentState!.validate()) {
                                  if (selectedInterests.isEmpty) {
                                    showAppToast(
                                      message:
                                          'الرجاء اختيار اهتمام واحد على الأقل',
                                      type: ToastType.failure,
                                    );
                                    return;
                                  }

                                  bloc.intersetsController.text =
                                      selectedInterests.join(', ');

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
                          padding: const EdgeInsets.only(top: 16, bottom: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
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
