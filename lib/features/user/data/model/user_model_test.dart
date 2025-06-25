// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class userModelTest {
  String id;
  String name;
  String phone;
  String email;
  String? state;

  userModelTest({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    this.state,
  });

  userModelTest copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? state,
  }) {
    return userModelTest(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      state: state ?? this.state,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'state': state,
    };
  }

  factory userModelTest.fromMap(Map<String, dynamic> map) {
    return userModelTest(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      phone: map['phone']?.toString() ?? '',
      email: map['email']?.toString() ?? '',
      state: map['state']?.toString(),
    );
  }

  String toJson() => json.encode(toMap());

  factory userModelTest.fromJson(String source) =>
      userModelTest.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'userModel(id: $id, name: $name, phone: $phone, email: $email, state: $state)';

  @override
  bool operator ==(covariant userModelTest other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.phone == phone &&
        other.email == email &&
        other.state == state;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      phone.hashCode ^
      email.hashCode ^
      state.hashCode;
}
