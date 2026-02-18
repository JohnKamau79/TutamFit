import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutam_fit/models/user_model.dart';
import 'package:tutam_fit/repositories/user_repository.dart';

// Repository instance
final userRepositoryProvider = Provider<UserRepository>((ref) => UserRepository());

// Stream provider for all users
final allUsersProvider = StreamProvider<List<UserModel>>((ref) {
  final repo = ref.watch(userRepositoryProvider);
  return repo.getAllUsers();
});