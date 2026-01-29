import 'package:firebase_auth/firebase_auth.dart';

class UserEntity {
  final String uid;
  final String? name;
  final String? email;
  final String? photoUrl;

  UserEntity({required this.uid, this.name, this.email, this.photoUrl});

  factory UserEntity.fromFirebaseUser(User user) {
    return UserEntity(
      uid: user.uid,
      name: user.displayName,
      email: user.email,
      photoUrl: user.photoURL,
    );
  }
}
