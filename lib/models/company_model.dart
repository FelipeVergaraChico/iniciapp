class CompanyModel {
  final String id;
  final String name;
  final String email;
  final String? cnpj;
  final String? phone;
  final String? address;
  final String? website;
  final String? logo;
  final String description;
  final String sector; // Tecnologia, Logística, Varejo, etc
  final int employeesCount;
  final List<String> benefits;
  final DateTime createdAt;

  CompanyModel({
    required this.id,
    required this.name,
    required this.email,
    this.cnpj,
    this.phone,
    this.address,
    this.website,
    this.logo,
    required this.description,
    required this.sector,
    required this.employeesCount,
    required this.benefits,
    required this.createdAt,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      cnpj: json['cnpj'] as String?,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      website: json['website'] as String?,
      logo: json['logo'] as String?,
      description: json['description'] as String,
      sector: json['sector'] as String,
      employeesCount: json['employeesCount'] as int,
      benefits: List<String>.from(json['benefits'] as List),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'cnpj': cnpj,
      'phone': phone,
      'address': address,
      'website': website,
      'logo': logo,
      'description': description,
      'sector': sector,
      'employeesCount': employeesCount,
      'benefits': benefits,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

enum JobType {
  fullTime('Tempo Integral'),
  partTime('Meio Período'),
  internship('Estágio'),
  apprentice('Jovem Aprendiz'),
  freelance('Freelance'),
  temporary('Temporário');

  final String label;
  const JobType(this.label);
}

enum WorkMode {
  onSite('Presencial'),
  remote('Remoto'),
  hybrid('Híbrido');

  final String label;
  const WorkMode(this.label);
}

class JobPostingModel {
  final String id;
  final String companyId;
  final String title;
  final String description;
  final JobType type;
  final WorkMode workMode;
  final String location;
  final String? salaryRange;
  final List<String> requirements; // Requisitos técnicos
  final List<String> responsibilities; // Responsabilidades
  final List<String> benefits;
  final List<String> skills; // Competências desejadas
  final String? experienceLevel; // Júnior, Pleno, Sênior
  final DateTime postedAt;
  final DateTime? expiresAt;
  final bool isActive;
  final int vacancies; // Número de vagas

  JobPostingModel({
    required this.id,
    required this.companyId,
    required this.title,
    required this.description,
    required this.type,
    required this.workMode,
    required this.location,
    this.salaryRange,
    required this.requirements,
    required this.responsibilities,
    required this.benefits,
    required this.skills,
    this.experienceLevel,
    required this.postedAt,
    this.expiresAt,
    this.isActive = true,
    this.vacancies = 1,
  });

  factory JobPostingModel.fromJson(Map<String, dynamic> json) {
    return JobPostingModel(
      id: json['id'] as String,
      companyId: json['companyId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      type: JobType.values.firstWhere((e) => e.name == json['type']),
      workMode: WorkMode.values.firstWhere((e) => e.name == json['workMode']),
      location: json['location'] as String,
      salaryRange: json['salaryRange'] as String?,
      requirements: List<String>.from(json['requirements'] as List),
      responsibilities: List<String>.from(json['responsibilities'] as List),
      benefits: List<String>.from(json['benefits'] as List),
      skills: List<String>.from(json['skills'] as List),
      experienceLevel: json['experienceLevel'] as String?,
      postedAt: DateTime.parse(json['postedAt'] as String),
      expiresAt: json['expiresAt'] != null
          ? DateTime.parse(json['expiresAt'] as String)
          : null,
      isActive: json['isActive'] as bool? ?? true,
      vacancies: json['vacancies'] as int? ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'companyId': companyId,
      'title': title,
      'description': description,
      'type': type.name,
      'workMode': workMode.name,
      'location': location,
      'salaryRange': salaryRange,
      'requirements': requirements,
      'responsibilities': responsibilities,
      'benefits': benefits,
      'skills': skills,
      'experienceLevel': experienceLevel,
      'postedAt': postedAt.toIso8601String(),
      'expiresAt': expiresAt?.toIso8601String(),
      'isActive': isActive,
      'vacancies': vacancies,
    };
  }
}

class CandidateMatchResult {
  final String candidateId;
  final String candidateName;
  final double overallScore; // 0-100
  final Map<String, double> skillScores; // skill -> score
  final List<String> matchedSkills;
  final List<String> missingSkills;
  final String suggestedArea;
  final int totalXP;
  final int completedTrails;
  final String reasoning; // Explicação do match gerada por IA

  CandidateMatchResult({
    required this.candidateId,
    required this.candidateName,
    required this.overallScore,
    required this.skillScores,
    required this.matchedSkills,
    required this.missingSkills,
    required this.suggestedArea,
    required this.totalXP,
    required this.completedTrails,
    required this.reasoning,
  });
}
