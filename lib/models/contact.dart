import 'dart:convert';

class Contact {
  String id;
  String name;
  String phone;
  String address;
  String email;
  String note;
  bool isFavorite;
  String group;

  Contact({
    required this.id,
    required this.name,
    required this.phone,
    this.address = '',
    this.email = '',
    this.note = '',
    this.isFavorite = false,
    this.group = 'Chưa phân nhóm',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'address': address,
      'email': email,
      'note': note,
      'isFavorite': isFavorite,
      'group': group,
    };
  }

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      address: map['address'] ?? '',
      email: map['email'] ?? '',
      note: map['note'] ?? '',
      isFavorite: map['isFavorite'] ?? false,
      group: map['group'] ?? 'Chưa phân nhóm',
    );
  }

  String toJson() => json.encode(toMap());
  factory Contact.fromJson(String source) => Contact.fromMap(json.decode(source));
}