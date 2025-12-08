import 'package:flutter/foundation.dart';
import '../models/development_resource_model.dart';
import '../models/professional_profile_model.dart';

class DevelopmentResourcesProvider extends ChangeNotifier {
  List<DevelopmentResource> _resources = [];
  DevelopmentResourceType? _selectedType;
  String _searchQuery = '';

  List<DevelopmentResource> get resources => _filteredResources;
  DevelopmentResourceType? get selectedType => _selectedType;
  String get searchQuery => _searchQuery;

  List<DevelopmentResource> get _filteredResources {
    var filtered = _resources;

    // Filtra por tipo
    if (_selectedType != null) {
      filtered = filtered.where((r) => r.type == _selectedType).toList();
    }

    // Filtra por busca
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((r) {
        return r.title.toLowerCase().contains(query) ||
            r.institution.toLowerCase().contains(query) ||
            r.description.toLowerCase().contains(query) ||
            r.skills.any((s) => s.toLowerCase().contains(query));
      }).toList();
    }

    // Ordena: patrocinados primeiro, depois por match score
    filtered.sort((a, b) {
      if (a.isSponsored && !b.isSponsored) return -1;
      if (!a.isSponsored && b.isSponsored) return 1;
      return b.matchScore.compareTo(a.matchScore);
    });

    return filtered;
  }

  void setTypeFilter(DevelopmentResourceType? type) {
    _selectedType = type;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // Carrega recomendações baseadas no perfil profissional
  void loadRecommendations(ProfessionalProfile? profile) {
    _resources = _generateRecommendations(profile);
    notifyListeners();
  }

  // Registra clique em um recurso (para analytics/tracking)
  void trackResourceClick(String resourceId) {
    if (kDebugMode) {
      print('📊 Resource clicked: $resourceId');
    }
    // Aqui você pode enviar para analytics (Firebase, Amplitude, etc)
  }

  // Registra inscrição em um recurso
  void trackEnrollment(String resourceId) {
    if (kDebugMode) {
      print('✅ Enrollment tracked: $resourceId');
    }
    // Aqui você pode enviar conversão para analytics
  }

  List<DevelopmentResource> _generateRecommendations(
    ProfessionalProfile? profile,
  ) {
    // Mock de recomendações - em produção viria de uma API
    final suggestedArea = profile?.suggestedArea ?? 'Administrativo';

    return [
      // CURSO - Alta afinidade administrativa
      DevelopmentResource(
        id: 'curso-1',
        title: 'Noções Básicas de Administração',
        institution: 'SENAI',
        type: DevelopmentResourceType.course,
        format: DeliveryFormat.online,
        duration: '12h',
        cost: 'Gratuito',
        skills: [
          'Organização',
          'Análise de informações',
          'Noções de processos',
        ],
        recommendationReason:
            'Você tem alta afinidade com a área $suggestedArea',
        description:
            'Aprenda os fundamentos da administração empresarial, incluindo planejamento, organização e controle de processos.',
        matchScore: 95,
        linkUrl: 'https://www.senai.br',
        isSponsored: false,
      ),

      // WORKSHOP PATROCINADO
      DevelopmentResource(
        id: 'workshop-1',
        title: 'Comunicação Profissional para Jovens',
        institution: 'SESC',
        type: DevelopmentResourceType.workshop,
        format: DeliveryFormat.inPerson,
        duration: '4h',
        cost: 'R\$ 50,00',
        skills: [
          'Comunicação verbal',
          'Apresentações',
          'Networking',
        ],
        recommendationReason:
            'Desenvolva habilidades essenciais de comunicação',
        description:
            'Workshop prático sobre comunicação efetiva no ambiente profissional, com dinâmicas e simulações.',
        matchScore: 88,
        location: 'SESC Paulista - São Paulo/SP',
        startDate: DateTime.now().add(const Duration(days: 15)),
        isSponsored: true,
        sponsorName: 'SESC',
      ),

      // PALESTRA
      DevelopmentResource(
        id: 'palestra-1',
        title: 'Como Conseguir o Primeiro Emprego',
        institution: 'CIEE',
        type: DevelopmentResourceType.lecture,
        format: DeliveryFormat.online,
        duration: '1h30',
        cost: 'Gratuito',
        skills: [
          'Preparação para entrevistas',
          'Currículo',
          'LinkedIn',
        ],
        recommendationReason:
            'Prepare-se para conquistar sua primeira vaga',
        description:
            'Palestra com especialistas em recrutamento sobre estratégias para conseguir o primeiro emprego.',
        matchScore: 92,
        startDate: DateTime.now().add(const Duration(days: 5)),
        linkUrl: 'https://www.ciee.org.br',
        isSponsored: false,
      ),

      // EVENTO
      DevelopmentResource(
        id: 'evento-1',
        title: 'Feira de Oportunidades e Estágios 2025',
        institution: 'Prefeitura de São Paulo',
        type: DevelopmentResourceType.event,
        format: DeliveryFormat.inPerson,
        duration: '2 dias',
        cost: 'Gratuito',
        skills: [
          'Networking',
          'Mercado de trabalho',
          'Oportunidades',
        ],
        recommendationReason:
            'Conecte-se com empresas que buscam profissionais',
        description:
            'Evento com mais de 50 empresas oferecendo vagas de emprego e estágio para jovens.',
        matchScore: 90,
        location: 'Anhembi Parque - São Paulo/SP',
        startDate: DateTime.now().add(const Duration(days: 30)),
        isSponsored: false,
      ),

      // CURSO PATROCINADO - Tecnologia
      DevelopmentResource(
        id: 'curso-2',
        title: 'Introdução à Programação Python',
        institution: 'Alura',
        type: DevelopmentResourceType.course,
        format: DeliveryFormat.online,
        duration: '20h',
        cost: 'Gratuito por 7 dias',
        skills: [
          'Programação',
          'Lógica',
          'Python',
        ],
        recommendationReason:
            'Desenvolva habilidades em tecnologia, área em alta demanda',
        description:
            'Curso completo de Python do zero, com projetos práticos e certificado.',
        matchScore: 85,
        linkUrl: 'https://www.alura.com.br',
        isSponsored: true,
        sponsorName: 'Alura',
      ),

      // ATIVIDADE PRÁTICA
      DevelopmentResource(
        id: 'atividade-1',
        title: 'Desafio: Organize um Projeto Real',
        institution: 'IniciApp',
        type: DevelopmentResourceType.practicalActivity,
        format: DeliveryFormat.online,
        duration: '2 semanas',
        cost: 'Gratuito',
        skills: [
          'Gestão de projetos',
          'Organização',
          'Trabalho em equipe',
        ],
        recommendationReason:
            'Pratique suas habilidades em um projeto real',
        description:
            'Desafio prático onde você coordena um mini-projeto, aplicando conceitos de gestão.',
        matchScore: 87,
        isSponsored: false,
      ),

      // WORKSHOP - Logística
      DevelopmentResource(
        id: 'workshop-2',
        title: 'Gestão de Estoque e Logística',
        institution: 'SENAC',
        type: DevelopmentResourceType.workshop,
        format: DeliveryFormat.hybrid,
        duration: '8h',
        cost: 'R\$ 120,00',
        skills: [
          'Controle de estoque',
          'Logística',
          'Organização',
        ],
        recommendationReason:
            'Aprenda fundamentos essenciais de logística',
        description:
            'Workshop prático sobre gestão de estoque, movimentação e controle de materiais.',
        matchScore: 82,
        location: 'SENAC - Diversos polos',
        startDate: DateTime.now().add(const Duration(days: 20)),
        isSponsored: false,
      ),

      // PALESTRA PATROCINADA
      DevelopmentResource(
        id: 'palestra-2',
        title: 'Inteligência Emocional no Trabalho',
        institution: 'Linkedin Learning',
        type: DevelopmentResourceType.lecture,
        format: DeliveryFormat.online,
        duration: '45min',
        cost: 'Gratuito',
        skills: [
          'Inteligência emocional',
          'Autoconhecimento',
          'Relacionamento interpessoal',
        ],
        recommendationReason:
            'Habilidade essencial para todas as áreas',
        description:
            'Palestra sobre como desenvolver inteligência emocional para melhorar performance profissional.',
        matchScore: 89,
        linkUrl: 'https://www.linkedin.com/learning',
        startDate: DateTime.now().add(const Duration(days: 3)),
        isSponsored: true,
        sponsorName: 'LinkedIn Learning',
      ),
    ];
  }
}
