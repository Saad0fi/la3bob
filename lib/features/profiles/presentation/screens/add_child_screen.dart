import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:go_router/go_router.dart';
import 'package:la3bob/core/di/injection.dart';
import 'package:la3bob/features/auth/domain/usecases/auth_use_cases.dart';
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
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
           
              if (context.canPop()) {
                context.pop(true);
              } else {
                context.go('/tabs/videos');
              }
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
              final isLoading = state is PorfileLoading;

              if (isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              return SingleChildScrollView(
                padding: .all(4.w),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 2.h),
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
                      SizedBox(height: 2.h),
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
                      SizedBox(height: 2.h),

                      InterestsSelector(
                        selectedInterests: selectedInterests,
                        onChanged: (interests) {
                          selectedInterests
                            ..clear()
                            ..addAll(interests);
                        },
                      ),

                      SizedBox(height: 4.h),
                      ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () {
                                if (formKey.currentState!.validate()) {
                                  if (selectedInterests.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'الرجاء اختيار اهتمام واحد على الأقل',
                                          style: TextStyle(fontSize: 10.dp),
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
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
                          padding: EdgeInsets.all(2.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2.w),
                          ),
                        ),
                        child: isLoading
                            ? SizedBox(
                                height: 5.w,
                                width: 5.w,
                                child: CircularProgressIndicator(
                                  strokeWidth: 0.5.w,
                                ),
                              )
                            : Text(
                                'إضافة الطفل',
                                style: TextStyle(fontSize: 12.dp),
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
