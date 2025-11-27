import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:la3bob/core/setup/setup.dart';
import 'package:la3bob/features/auth/domain/usecases/auth_use_cases.dart';
import 'package:la3bob/features/auth/presentation/pages/login_screen.dart';
import 'package:la3bob/features/profiles/domain/entities/child_entity.dart';
import 'package:la3bob/features/profiles/domain/usecase/profile_usecase.dart';
import 'package:la3bob/features/profiles/presentation/bloc/porfile_bloc.dart';
import 'package:la3bob/features/profiles/presentation/screens/add_child_screen.dart';
import 'package:la3bob/features/profiles/presentation/screens/update_child_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PorfileBloc(
            getIt<ProfileUsecase>(),
            getIt<AuthUseCases>(),
          )..add(const LoadChildren()),
      child: Builder(
        builder: (context) {
          final bloc = context.read<PorfileBloc>();
          return Scaffold(
            appBar: AppBar(
              title: const Text('الملف الشخصي'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () async {
                    final result = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const AddChildScreen(),
                      ),
                    );
                    if (result == true) {
                      bloc.add(const LoadChildren());
                    }
                  },
                ),
              ],
            ),
            body: BlocListener<PorfileBloc, PorfileState>(
              listener: (context, state) {
                if (state is PorfileSuccess && state.message == 'تم تسجيل الخروج بنجاح') {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (_) => const LoginScreen(),
                    ),
                    (route) => false,
                  );
                }
              },
              child: BlocBuilder<PorfileBloc, PorfileState>(
                builder: (context, state) {
                if (state is PorfileLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is PorfileChildrenLoaded) {
                  if (state.children.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: .min,
                        children: [
                          const Text('لا يوجد أطفال مسجلين بعد'),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const AddChildScreen(),
                                ),
                              );
                            },
                            child: const Text('إضافة طفل'),
                          ),
                        ],
                      ),
                    );
                  }
                  final children = state.children;
                  final data = children.map((child) {
                    return ListTile(
                      title: Text(
                        child.name,
                        textDirection: TextDirection.rtl,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: .start,
                        children: [
                          Text(
                            'العمر: ${child.age}',
                            textDirection: TextDirection.rtl,
                          ),
                          Text(
                            'الاهتمامات: ${child.intersets.join('، ')}',
                            textDirection: TextDirection.rtl,
                          ),
                          const Text(
                            'مدة المشاهدة: 0 دقيقة',
                            textDirection: TextDirection.rtl,
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.manage_accounts),
                        onPressed: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => UpdateChildScreen(child: child),
                            ),
                          );
                        },
                      ),
                    );
                  }).toList();

                  data.add(
                    ListTile(
                      leading: const Icon(Icons.logout),
                      title: const Text('تسجيل الخروج'),
                      onTap: () => bloc.add(const LogoutRequested()),
                    ),
                  );

                  return ListView.builder(
                    padding: const .only(top: 8, bottom: 8),
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          data[index],
                          if (index < data.length - 1)
                            const Divider(height: 1),
                        ],
                      );
                    },
                  );
                }

                if (state is PorfileError) {
                  return Center(
                    child: Column(
                      mainAxisSize: .min,
                      children: [
                        Text(state.error, textAlign: TextAlign.center),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () => bloc.add(const LoadChildren()),
                          child: const Text('إعادة المحاولة'),
                        ),
                      ],
                    ),
                  );
                }

                if (state is PorfileSuccess) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  });
                }

                return const SizedBox.shrink();
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

