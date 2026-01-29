import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recallhub_frontend/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:recallhub_frontend/features/dashboard/dashboard_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return DashboardPage(); //  rebuilds on AuthState change
      },
    );
  }
}
