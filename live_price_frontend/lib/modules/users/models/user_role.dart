enum UserRole {
  admin(0, 'Admin'),
  customer(1, 'Customer');

  final int id;
  final String name;

  const UserRole(this.id, this.name);

  static UserRole fromId(int id) {
    return UserRole.values.firstWhere(
      (e) => e.id == id,
      orElse: () => throw Exception('Geçersiz kullanıcı rolü: $id'),
    );
  }

  @override
  String toString() => name;
}
