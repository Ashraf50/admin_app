import 'service.dart';
import 'user.dart';

class ManagerModel {
  int? id;
  Service? service;
  User? user;

  ManagerModel({this.id, this.service, this.user});

  factory ManagerModel.fromJson(Map<String, dynamic> json) => ManagerModel(
        id: json['id'] as int?,
        service: json['service'] == null
            ? null
            : Service.fromJson(json['service'] as Map<String, dynamic>),
        user: json['user'] == null
            ? null
            : User.fromJson(json['user'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'service': service?.toJson(),
        'user': user?.toJson(),
      };
}
