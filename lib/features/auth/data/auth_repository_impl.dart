import 'package:firebase_auth/firebase_auth.dart';
import 'package:recallhub_frontend/features/auth/data/services/local_user_storage.dart';
import 'package:recallhub_frontend/features/auth/domain/entities/user_entity.dart';
import 'package:recallhub_frontend/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
 // final ApiService _apiService = ApiService();

  @override
  Future<UserEntity?> signInWithGoogle() async {
    try {
      final googleProvider = GoogleAuthProvider();
      googleProvider.setCustomParameters({'prompt': 'select_account'});

      final userCredential = await _firebaseAuth.signInWithPopup(
        googleProvider,
      );

      final user = userCredential.user;
      // print(
      //   "Signed in user: ${user?.uid}, ${user?.displayName}, ${user?.email}, ${user?.photoURL}",
      // );

      if (user == null) return null;

      // Save locally
      await LocalUserStorage.saveUser(
        uid: user.uid,
        name: user.displayName ?? "",
        email: user.email ?? "",
        photoUrl: user.photoURL ?? "",
      );
      return UserEntity(
        uid: user.uid,
        name: user.displayName ?? "UnKnown",
        email: user.email ?? "",
        photoUrl: user.photoURL ?? "",
      );
    } catch (e) {
     // print("Google Sign-In failed: $e");
      return null;
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
