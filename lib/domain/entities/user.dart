/// User entity - represents a user in the domain
class User {
  final String id;
  final String email;
  final String name;
  final String role;
  final String? phoneNumber;
  final String? avatarUrl;
  final DateTime createdAt;

  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.phoneNumber,
    this.avatarUrl,
    required this.createdAt,
  });

  bool get isUser => role == 'user';
  bool get isProvider => role == 'provider';
  bool get isAdmin => role == 'admin';
}
