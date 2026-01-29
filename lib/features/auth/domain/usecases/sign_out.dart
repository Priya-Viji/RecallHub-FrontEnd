// features/auth/domain/usecases/sign_out.dart

import 'package:recallhub_frontend/features/auth/domain/repositories/auth_repository.dart';

class SignOut {
  final AuthRepository repository;

  SignOut(this.repository);

  Future<void> call() async {
    return await repository.signOut();
  }
}
