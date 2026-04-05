import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/auth_user.dart';

part 'auth_user_model.g.dart';

@JsonSerializable()
class AuthUserDto {
  final String id;
  final String email;
  @JsonKey(name: 'username')
  final String? username;
  @JsonKey(name: 'photo_url')
  final String? photoUrl;

  const AuthUserDto({
    required this.id,
    required this.email,
    this.username,
    this.photoUrl,
  });

  factory AuthUserDto.fromJson(Map<String, dynamic> json) =>
      _$AuthUserDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AuthUserDtoToJson(this);
}

extension AuthUserDtoMapper on AuthUserDto {
  AuthUser toEntity() => AuthUser(
        id: id,
        email: email,
        username: username,
        photoUrl: photoUrl,
      );
}
