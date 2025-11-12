enum JobCategory {
  administration,
  sales,
  customerService,
  technology,
  logistics,
  retail,
  other,
}

enum ExperienceLevel {
  none,
  basic,
  intermediate,
}

class JobModel {
  final String id;
  final String companyId;
  final String companyName;
  final String title;
  final String description;
  final JobCategory category;
  final ExperienceLevel experienceLevel;
  final String location;
  final bool isRemote;
  final String? salaryRange;
  final List<String> requiredSkills;
  final List<String> requiredTrails;
  final int minimumLevel;
  final DateTime postedAt;
  final DateTime expiresAt;
  final bool isActive;

  JobModel({
    required this.id,
    required this.companyId,
    required this.companyName,
    required this.title,
    required this.description,
    required this.category,
    required this.experienceLevel,
    required this.location,
    this.isRemote = false,
    this.salaryRange,
    required this.requiredSkills,
    required this.requiredTrails,
    this.minimumLevel = 1,
    required this.postedAt,
    required this.expiresAt,
    this.isActive = true,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      id: json['id'] as String,
      companyId: json['companyId'] as String,
      companyName: json['companyName'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: JobCategory.values.firstWhere(
        (e) => e.toString() == 'JobCategory.${json['category']}',
      ),
      experienceLevel: ExperienceLevel.values.firstWhere(
        (e) => e.toString() == 'ExperienceLevel.${json['experienceLevel']}',
      ),
      location: json['location'] as String,
      isRemote: json['isRemote'] as bool? ?? false,
      salaryRange: json['salaryRange'] as String?,
      requiredSkills: List<String>.from(json['requiredSkills'] as List),
      requiredTrails: List<String>.from(json['requiredTrails'] as List),
      minimumLevel: json['minimumLevel'] as int? ?? 1,
      postedAt: DateTime.parse(json['postedAt'] as String),
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'companyId': companyId,
      'companyName': companyName,
      'title': title,
      'description': description,
      'category': category.toString().split('.').last,
      'experienceLevel': experienceLevel.toString().split('.').last,
      'location': location,
      'isRemote': isRemote,
      'salaryRange': salaryRange,
      'requiredSkills': requiredSkills,
      'requiredTrails': requiredTrails,
      'minimumLevel': minimumLevel,
      'postedAt': postedAt.toIso8601String(),
      'expiresAt': expiresAt.toIso8601String(),
      'isActive': isActive,
    };
  }
}

class JobMatch {
  final JobModel job;
  final double matchPercentage;
  final List<String> matchingSkills;
  final List<String> missingSkills;
  final bool meetsLevelRequirement;

  JobMatch({
    required this.job,
    required this.matchPercentage,
    required this.matchingSkills,
    required this.missingSkills,
    required this.meetsLevelRequirement,
  });
}
