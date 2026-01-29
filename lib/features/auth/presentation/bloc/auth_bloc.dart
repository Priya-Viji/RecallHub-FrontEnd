import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recallhub_frontend/features/auth/data/services/local_user_storage.dart';
import 'package:recallhub_frontend/features/auth/domain/entities/user_entity.dart';
import 'package:recallhub_frontend/features/auth/domain/repositories/auth_repository.dart';

// EVENTS
abstract class AuthEvent {}

class SignInRequested extends AuthEvent {}

class SignOutRequested extends AuthEvent {}

class CheckAuthStatus extends AuthEvent {}

// STATES
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final UserEntity user;
  Authenticated(this.user);
}

class Unauthenticated extends AuthState {}

// BLOC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  //final ApiService _apiService = ApiService();

  AuthBloc(this._authRepository) : super(AuthInitial()) {
    // ------------------------------------------------------------
    // 1. SIGN IN
    // ------------------------------------------------------------
    on<SignInRequested>((event, emit) async {
      emit(AuthLoading());

      final user = await _authRepository.signInWithGoogle();

      if (user != null) {
        // Save user locally
        await LocalUserStorage.saveUser(
          uid: user.uid,
          name: user.name ?? "",
          email: user.email ?? "",
          photoUrl: user.photoUrl ?? "",
        );

        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    });

    // ------------------------------------------------------------
    // 2. SIGN OUT
    // ------------------------------------------------------------
    on<SignOutRequested>((event, emit) async {
      await _authRepository.signOut();
      await LocalUserStorage.clearUser();
      emit(Unauthenticated());
    });

    // ------------------------------------------------------------
    // 3. CHECK AUTH STATUS ON APP START
    // ------------------------------------------------------------
    on<CheckAuthStatus>((event, emit) async {
      emit(AuthLoading());

      // A. Check local storage first
      final localUser = await LocalUserStorage.loadUser();

      if (localUser != null) {
        emit(
          Authenticated(
            UserEntity(
              uid: localUser["uid"] ?? "",
              name: localUser["name"] ?? "",
              email: localUser["email"] ?? "",
              photoUrl: localUser["photo"] ?? "",
            ),
          ),
        );
        return;
      }

      // B. Check Firebase user
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        emit(
          Authenticated(
            UserEntity(
              uid: currentUser.uid,
              name: currentUser.displayName ?? "",
              email: currentUser.email ?? "",
              photoUrl: currentUser.photoURL ?? "",
            ),
          ),
        );
        return;
      }

      // C. No user found
      emit(Unauthenticated());
    });
  }
}
