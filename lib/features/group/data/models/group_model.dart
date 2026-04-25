// ─────────────────────────────────────────────────────────────────────────────
// Group Feature Models
// Single model file following the project's clean code structure.
// ─────────────────────────────────────────────────────────────────────────────

// ─── Hajji: Group Info ────────────────────────────────────────────────────────

class GroupInfoModel {
  final String groupName;
  final int pilgrimsCount;
  final String supervisorName;

  // Group Campaign Dates
  final String arrivalDate;
  final String departureDate;

  // Supervisor Contacts
  final String supervisorYemeniNumber;
  final String supervisorSaudiNumber;
  final String supervisorWhatsApp;
  final String supervisorEmail;

  GroupInfoModel({
    required this.groupName,
    required this.pilgrimsCount,
    required this.supervisorName,
    required this.arrivalDate,
    required this.departureDate,
    required this.supervisorYemeniNumber,
    required this.supervisorSaudiNumber,
    required this.supervisorWhatsApp,
    required this.supervisorEmail,
  });

  factory GroupInfoModel.fromJson(Map<String, dynamic> json) {
    return GroupInfoModel(
      groupName: json['groupName']?.toString() ?? '—',
      pilgrimsCount: json['pilgrimsCount'] as int? ?? 0,
      supervisorName: json['supervisorName']?.toString() ?? '—',
      arrivalDate: json['arrivalDate']?.toString() ?? '—',
      departureDate: json['departureDate']?.toString() ?? '—',
      supervisorYemeniNumber:
          json['supervisorYemeniNumber']?.toString() ?? '—',
      supervisorSaudiNumber:
          json['supervisorSaudiNumber']?.toString() ?? '—',
      supervisorWhatsApp: json['supervisorWhatsApp']?.toString() ?? '—',
      supervisorEmail: json['supervisorEmail']?.toString() ?? '—',
    );
  }
}

// ─── Supervisor: Group + Pilgrim List ────────────────────────────────────────

class SupervisorGroupModel {
  final String groupName;
  final int membersCount;
  final List<SupervisorPilgrimModel> pilgrims;

  SupervisorGroupModel({
    required this.groupName,
    required this.membersCount,
    required this.pilgrims,
  });

  factory SupervisorGroupModel.fromJson(Map<String, dynamic> json) {
    return SupervisorGroupModel(
      groupName: json['groupName']?.toString() ?? '—',
      membersCount: json['membersCount'] as int? ?? 0,
      pilgrims: (json['pilgrims'] as List<dynamic>?)
              ?.map(
                  (e) => SupervisorPilgrimModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class SupervisorPilgrimModel {
  final int userId;
  final String fullName;
  final bool isHealthStable;

  SupervisorPilgrimModel({
    required this.userId,
    required this.fullName,
    required this.isHealthStable,
  });

  factory SupervisorPilgrimModel.fromJson(Map<String, dynamic> json) {
    return SupervisorPilgrimModel(
      userId: json['userId'] as int? ?? 0,
      fullName: json['fullName']?.toString() ?? '—',
      isHealthStable: json['isHealthStable'] as bool? ?? true,
    );
  }
}

// ─── Supervisor: Pilgrim Details ─────────────────────────────────────────────

class PilgrimDetailsModel {
  final String fullName;
  final String jobTitle;
  final String healthStatus;
  final String? healthNote;
  final String gender;
  final String dateOfBirth;
  final String passportNumber;
  final String placeResidence;
  final String saudiNumber;
  final String yemeniNumber;
  final String whatsappNumber;
  final PilgrimEmergencyContact emergencyContact;

  PilgrimDetailsModel({
    required this.fullName,
    required this.jobTitle,
    required this.healthStatus,
    this.healthNote,
    required this.gender,
    required this.dateOfBirth,
    required this.passportNumber,
    required this.placeResidence,
    required this.saudiNumber,
    required this.yemeniNumber,
    required this.whatsappNumber,
    required this.emergencyContact,
  });

  factory PilgrimDetailsModel.fromJson(Map<String, dynamic> json) {
    return PilgrimDetailsModel(
      fullName: json['fullName']?.toString() ?? '—',
      jobTitle: json['jobTitle']?.toString() ?? '—',
      healthStatus: json['healthStatus']?.toString() ?? '—',
      healthNote: json['healthNote']?.toString(),
      gender: json['gender']?.toString() ?? '—',
      dateOfBirth: json['dateOfBirth']?.toString() ?? '—',
      passportNumber: json['passportNumber']?.toString() ?? '—',
      placeResidence: json['placeResidence']?.toString() ?? '—',
      saudiNumber: json['saudiNumber']?.toString() ?? '—',
      yemeniNumber: json['yemeniNumber']?.toString() ?? '—',
      whatsappNumber: json['whatsappNumber']?.toString() ?? '—',
      emergencyContact: json['emergencyContact'] != null
          ? PilgrimEmergencyContact.fromJson(
              json['emergencyContact'] as Map<String, dynamic>)
          : PilgrimEmergencyContact(name: '—', phone: '—'),
    );
  }
}

class PilgrimEmergencyContact {
  final String name;
  final String phone;

  PilgrimEmergencyContact({
    required this.name,
    required this.phone,
  });

  factory PilgrimEmergencyContact.fromJson(Map<String, dynamic> json) {
    return PilgrimEmergencyContact(
      name: json['name']?.toString() ?? '—',
      phone: json['phone']?.toString() ?? '—',
    );
  }
}
