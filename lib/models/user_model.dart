import 'package:objectbox/objectbox.dart';

@Entity()
class UserModel {
  int id;
  final String firstName;
  final String lastName;
  final String userName;
  final String email;
  final String accountType;
  final String password;

  UserModel({
    this.id = 0,
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.email,
    required this.accountType,
    required this.password
  });
}