class UserModel {
  const UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.middleName,
    this.phoneNumber,
    this.birthDate,
    this.gender,
    this.address,
    this.city,
    this.country,
    this.profilePictureUrl,
    required this.isAdmin,
  });

  final int id;
  final String firstName;
  final String? middleName;
  final String lastName;
  final String email;
  final String? phoneNumber;
  final DateTime? birthDate;
  final String? gender;
  final String? address;
  final String? city;
  final String? country;
  final String? profilePictureUrl;
  final bool isAdmin;

  String get fullName {
    final parts = [firstName, middleName, lastName]
        .where((part) => part != null && part.trim().isNotEmpty)
        .map((part) => part!.trim());
    return parts.join(' ');
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      firstName: json['firstName'] as String,
      middleName: json['middleName'] as String?,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      birthDate: json['birthDate'] == null
          ? null
          : DateTime.parse(json['birthDate'] as String),
      gender: json['gender'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      country: json['country'] as String?,
      profilePictureUrl: json['profilePictureUrl'] as String?,
      isAdmin: json['isAdmin'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toUpdateJson() {
    return {
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'birthDate': birthDate?.toIso8601String(),
      'gender': gender,
      'address': address,
      'city': city,
      'country': country,
      'profilePictureUrl': profilePictureUrl,
    };
  }
}
