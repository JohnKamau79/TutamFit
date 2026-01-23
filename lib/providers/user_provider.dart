import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/user_repository.dart';
import '../models/user_model.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository();
});

final userProvider = StreamProvider.family<UserModel, String>((ref, uid) {
  final repo = ref.read(userRepositoryProvider);
  return repo.getUserById(uid);
});
