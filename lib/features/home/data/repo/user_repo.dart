import 'dart:io';

import 'package:admin_app/core/error/failure.dart';
import 'package:admin_app/features/home/data/model/user_model/user_model.dart';
import 'package:dartz/dartz.dart';

abstract class UserRepo {
  Future<Either<Failure, UserModel>> fetchUserData({
    required String token,
  });
  Future<Either<Failure, UserModel>> updateData({
    required String name,
    required String email,
    required String phone,
    required File avatar,
  });
}
