class ProfileModel {
  final String id;
  final String fullName;
  final String email;
  final String packageTier;

  ProfileModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.packageTier,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] ?? '',
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      packageTier: json['package_tier'] ?? 'Free',
    );
  }
}