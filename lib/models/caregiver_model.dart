enum ExperienceLevel {
  basic, // 110 - 170 MXN
  intermediate, // 171 - 220 MXN
  advanced // up to 350 MXN
}

class CaregiverModel {
  final String id;
  final String bio;
  final int experienceYears;
  final List<String> certifications;
  final double hourlyRate;
  final ExperienceLevel level;
  final Map<String, List<String>> availability; // Ej: {"Lunes": ["08:00-12:00", "14:00-18:00"]}
  final String? photoUrl;

  CaregiverModel({
    required this.id,
    required this.bio,
    required this.experienceYears,
    required this.certifications,
    required this.hourlyRate,
    required this.level,
    required this.availability,
    this.photoUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bio': bio,
      'experienceYears': experienceYears,
      'certifications': certifications,
      'hourlyRate': hourlyRate,
      'level': level.toString(),
      'availability': availability,
      'photoUrl': photoUrl,
    };
  }
}
