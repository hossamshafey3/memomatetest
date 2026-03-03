// ─────────────────────────────────────────────
//  doctor_model.dart  –  Memomate
//  Models for Doctor registration & login.
// ─────────────────────────────────────────────

// ── Register Request ──────────────────────────
class DoctorRegisterModel {
  final String name;
  final String email;
  final String password;
  final String image;
  final String specialization;
  final String degree;
  final String experience;
  final String about;

  const DoctorRegisterModel({
    required this.name,
    required this.email,
    required this.password,
    required this.image,
    required this.specialization,
    required this.degree,
    required this.experience,
    required this.about,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'password': password,
    'image': image,
    'specialization': specialization,
    'degree': degree,
    'experience': experience,
    'about': about,
  };
}

// ── Login Request ─────────────────────────────
class DoctorLoginModel {
  final String email;
  final String password;

  const DoctorLoginModel({required this.email, required this.password});

  Map<String, dynamic> toJson() => {'email': email, 'password': password};
}

// ── Login Response Data ───────────────────────
class DoctorProfile {
  final String id;
  final String name;
  final String email;
  final String image;
  final String specialization;
  final String degree;
  final String experience;
  final String about;
  final bool available;
  final List<String> requests;
  final List<String> patients;
  final String createdAt;
  final String updatedAt;

  const DoctorProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.image,
    required this.specialization,
    required this.degree,
    required this.experience,
    required this.about,
    required this.available,
    this.requests = const [],
    this.patients = const [],
    this.createdAt = '',
    this.updatedAt = '',
  });

  factory DoctorProfile.fromJson(Map<String, dynamic> json) => DoctorProfile(
    id: json['_id'] as String? ?? '',
    name: json['name'] as String? ?? '',
    email: json['email'] as String? ?? '',
    image: json['image'] as String? ?? '',
    specialization: json['specialization'] as String? ?? '',
    degree: json['degree'] as String? ?? '',
    experience: json['experience'] as String? ?? '',
    about: json['about'] as String? ?? '',
    available: json['available'] as bool? ?? false,
    requests:
        (json['requests'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [],
    patients:
        (json['patients'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [],
    createdAt: json['createdAt'] as String? ?? '',
    updatedAt: json['updatedAt'] as String? ?? '',
  );
}

// ── Login Response (profile + JWT token) ─────
class DoctorLoginResponse {
  final String token;
  final DoctorProfile profile;

  const DoctorLoginResponse({required this.token, required this.profile});

  factory DoctorLoginResponse.fromJson(Map<String, dynamic> json) =>
      DoctorLoginResponse(
        token: json['token'] as String? ?? '',
        profile: DoctorProfile.fromJson(
          json['data'] as Map<String, dynamic>? ?? {},
        ),
      );
}
