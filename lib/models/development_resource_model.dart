/// Tipos de recursos de desenvolvimento
enum DevelopmentResourceType {
  course('Curso'),
  workshop('Workshop'),
  lecture('Palestra'),
  event('Evento'),
  practicalActivity('Atividade Prática');

  final String label;
  const DevelopmentResourceType(this.label);
}

/// Formato de entrega
enum DeliveryFormat {
  online('Online'),
  inPerson('Presencial'),
  hybrid('Híbrido');

  final String label;
  const DeliveryFormat(this.label);
}

/// Modelo de recurso de desenvolvimento (curso, palestra, etc)
class DevelopmentResource {
  final String id;
  final String title;
  final String institution;
  final DevelopmentResourceType type;
  final DeliveryFormat format;
  final String duration;
  final String cost;
  final List<String> skills; // Competências desenvolvidas
  final String recommendationReason;
  final String description;
  final String? imageUrl;
  final String? linkUrl;
  final DateTime? startDate;
  final String? location;
  final double matchScore; // 0-100 - quanto maior, melhor o match
  final bool isSponsored; // Se é anúncio pago
  final String? sponsorName;

  DevelopmentResource({
    required this.id,
    required this.title,
    required this.institution,
    required this.type,
    required this.format,
    required this.duration,
    required this.cost,
    required this.skills,
    required this.recommendationReason,
    required this.description,
    this.imageUrl,
    this.linkUrl,
    this.startDate,
    this.location,
    required this.matchScore,
    this.isSponsored = false,
    this.sponsorName,
  });

  factory DevelopmentResource.fromJson(Map<String, dynamic> json) {
    return DevelopmentResource(
      id: json['id'] as String,
      title: json['title'] as String,
      institution: json['institution'] as String,
      type: DevelopmentResourceType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => DevelopmentResourceType.course,
      ),
      format: DeliveryFormat.values.firstWhere(
        (e) => e.name == json['format'],
        orElse: () => DeliveryFormat.online,
      ),
      duration: json['duration'] as String,
      cost: json['cost'] as String,
      skills: List<String>.from(json['skills'] as List),
      recommendationReason: json['recommendationReason'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String?,
      linkUrl: json['linkUrl'] as String?,
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'] as String)
          : null,
      location: json['location'] as String?,
      matchScore: (json['matchScore'] as num).toDouble(),
      isSponsored: json['isSponsored'] as bool? ?? false,
      sponsorName: json['sponsorName'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'institution': institution,
      'type': type.name,
      'format': format.name,
      'duration': duration,
      'cost': cost,
      'skills': skills,
      'recommendationReason': recommendationReason,
      'description': description,
      'imageUrl': imageUrl,
      'linkUrl': linkUrl,
      'startDate': startDate?.toIso8601String(),
      'location': location,
      'matchScore': matchScore,
      'isSponsored': isSponsored,
      'sponsorName': sponsorName,
    };
  }

  // Retorna ícone baseado no tipo
  String get iconEmoji {
    switch (type) {
      case DevelopmentResourceType.course:
        return '📚';
      case DevelopmentResourceType.workshop:
        return '🛠️';
      case DevelopmentResourceType.lecture:
        return '🎤';
      case DevelopmentResourceType.event:
        return '🎪';
      case DevelopmentResourceType.practicalActivity:
        return '✍️';
    }
  }
}
