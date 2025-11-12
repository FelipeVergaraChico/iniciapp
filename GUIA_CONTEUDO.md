# 📚 Guia de Adição de Conteúdo - IniciApp

## Como Adicionar uma Nova Trilha

### 1. Defina a categoria no modelo
Edite `lib/models/trail_model.dart` se necessário adicionar nova categoria:

```dart
enum TrailCategory {
  // ... existentes
  novaCategoria,  // Adicione aqui
}
```

### 2. Crie os dados da trilha

Em `trails_screen.dart`, adicione ao método `_getMockTrails()`:

```dart
TrailModel(
  id: 'trail_unique_id',
  title: 'Nome da Trilha',
  description: 'Descrição detalhada do que o aluno vai aprender',
  type: TrailType.foundation, // ou professional
  category: TrailCategory.suaCategoria,
  iconPath: '', // Path do ícone (futuro)
  totalLessons: 15,
  estimatedHours: 8,
  lessonIds: ['lesson1', 'lesson2', 'lesson3'],
  requiredLevel: 1, // Nível mínimo necessário
),
```

### 3. Configure ícone e cor

Em `trails_screen.dart`, adicione nos métodos:

```dart
// Cor da categoria
Color _getCategoryColor(TrailCategory category) {
  switch (category) {
    case TrailCategory.suaCategoria:
      return AppColors.primary; // Escolha a cor
    // ...
  }
}

// Ícone da categoria
IconData _getCategoryIcon(TrailCategory category) {
  switch (category) {
    case TrailCategory.suaCategoria:
      return Icons.seu_icone;
    // ...
  }
}
```

## Como Adicionar uma Nova Lição

### 1. Crie o objeto Lesson

```dart
LessonModel(
  id: 'lesson_unique_id',
  trailId: 'trail_id_parent',
  title: 'Título da Lição',
  description: 'O que o aluno aprenderá nesta lição',
  type: LessonType.theory, // theory, practice, quiz, challenge
  difficulty: DifficultyLevel.easy, // easy, medium, hard
  pointsReward: 10,
  estimatedMinutes: 15,
  order: 1, // Ordem na trilha
  
  // Conteúdo da lição
  contentBlocks: [
    ContentBlock(
      type: 'text',
      content: 'Texto explicativo da teoria',
    ),
    ContentBlock(
      type: 'example',
      content: 'Exemplo prático',
      metadata: {'highlight': true},
    ),
    ContentBlock(
      type: 'image',
      content: 'assets/images/exemplo.png',
    ),
  ],
  
  // Perguntas (se for quiz)
  questions: [
    Question(
      id: 'q1',
      text: 'Qual é a pergunta?',
      points: 5,
      correctAnswerId: 'a1',
      explanation: 'Explicação da resposta correta',
      answers: [
        Answer(id: 'a1', text: 'Resposta correta'),
        Answer(id: 'a2', text: 'Resposta incorreta 1'),
        Answer(id: 'a3', text: 'Resposta incorreta 2'),
        Answer(id: 'a4', text: 'Resposta incorreta 3'),
      ],
    ),
  ],
)
```

### 2. Tipos de Blocos de Conteúdo

**Text Block** - Texto explicativo
```dart
ContentBlock(
  type: 'text',
  content: 'Seu texto aqui',
)
```

**Example Block** - Exemplo prático
```dart
ContentBlock(
  type: 'example',
  content: 'Exemplo: Como escrever um email profissional...',
  metadata: {'highlight': true, 'color': 'primary'},
)
```

**Image Block** - Imagem ilustrativa
```dart
ContentBlock(
  type: 'image',
  content: 'assets/images/diagram.png',
  metadata: {'caption': 'Legenda da imagem'},
)
```

**Video Block** - Vídeo explicativo (futuro)
```dart
ContentBlock(
  type: 'video',
  content: 'https://youtube.com/watch?v=...',
  metadata: {'duration': 300},
)
```

## Como Adicionar uma Nova Vaga

### 1. Defina a categoria se necessário

Em `job_model.dart`:

```dart
enum JobCategory {
  // ... existentes
  novaCategoria,
}
```

### 2. Crie o objeto Job

```dart
JobModel(
  id: 'job_unique_id',
  companyId: 'company_id',
  companyName: 'Nome da Empresa',
  title: 'Título da Vaga',
  description: 'Descrição completa da vaga e responsabilidades',
  category: JobCategory.administration,
  experienceLevel: ExperienceLevel.none, // none, basic, intermediate
  location: 'São Paulo, SP',
  isRemote: false,
  salaryRange: 'R$ 1.500 - R$ 2.000',
  
  // Habilidades requeridas
  requiredSkills: [
    'Comunicação',
    'Organização',
    'Excel',
  ],
  
  // Trilhas recomendadas
  requiredTrails: [
    'functionalLiteracy',
    'professionalWriting',
  ],
  
  minimumLevel: 1,
  postedAt: DateTime.now(),
  expiresAt: DateTime.now().add(Duration(days: 30)),
  isActive: true,
)
```

## Como Adicionar um Desafio Diário

### 1. Crie o sistema de desafios

```dart
class DailyChallenge {
  final String id;
  final String title;
  final String description;
  final String lessonId; // Lição que deve completar
  final int pointsReward;
  final DateTime date;
  
  DailyChallenge({
    required this.id,
    required this.title,
    required this.description,
    required this.lessonId,
    this.pointsReward = 20,
    required this.date,
  });
}
```

### 2. Gere desafios diários

```dart
DailyChallenge generateDailyChallenge() {
  final today = DateTime.now();
  final challenges = [
    {
      'title': 'Complete uma lição de Matemática',
      'lesson': 'math_lesson_1',
    },
    {
      'title': 'Pratique Interpretação de Texto',
      'lesson': 'reading_lesson_1',
    },
    // ... mais desafios
  ];
  
  // Seleciona desafio baseado no dia
  final index = today.day % challenges.length;
  final challenge = challenges[index];
  
  return DailyChallenge(
    id: 'daily_${today.toString().substring(0, 10)}',
    title: challenge['title']!,
    description: 'Complete para ganhar pontos extras!',
    lessonId: challenge['lesson']!,
    date: today,
  );
}
```

## Como Adicionar Badges

### 1. Defina tipos de badges

```dart
enum BadgeType {
  completion,    // Completou uma trilha
  streak,        // X dias consecutivos
  perfect,       // 100% de acerto
  speed,         // Velocidade
  mastery,       // Domínio completo
}

class Badge {
  final String id;
  final String title;
  final String description;
  final BadgeType type;
  final String iconPath;
  final int? requirement; // Ex: 7 para streak de 7 dias
  
  Badge({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.iconPath,
    this.requirement,
  });
}
```

### 2. Defina os badges

```dart
final List<Badge> badges = [
  Badge(
    id: 'first_lesson',
    title: 'Primeira Lição',
    description: 'Completou sua primeira lição',
    type: BadgeType.completion,
    iconPath: 'assets/badges/first_lesson.png',
  ),
  Badge(
    id: 'streak_7',
    title: 'Semana Completa',
    description: 'Manteve streak por 7 dias',
    type: BadgeType.streak,
    iconPath: 'assets/badges/streak_7.png',
    requirement: 7,
  ),
  Badge(
    id: 'trail_complete',
    title: 'Trilha Concluída',
    description: 'Completou uma trilha inteira',
    type: BadgeType.completion,
    iconPath: 'assets/badges/trail_complete.png',
  ),
  // ... mais badges
];
```

## Sistema de Progresso

### Atualizar progresso do usuário

```dart
// Em um provider ou service
void updateProgress({
  required String userId,
  required String trailId,
  required String lessonId,
  required int pointsEarned,
  required bool isCompleted,
}) {
  // 1. Atualiza progresso da lição
  final lessonProgress = LessonProgress(
    lessonId: lessonId,
    isCompleted: isCompleted,
    pointsEarned: pointsEarned,
    startedAt: DateTime.now(),
    completedAt: isCompleted ? DateTime.now() : null,
  );
  
  // 2. Atualiza progresso da trilha
  final trailProgress = ProgressModel(
    userId: userId,
    trailId: trailId,
    completedLessons: completedLessons + 1,
    totalLessons: totalLessons,
    progressPercentage: calculatePercentage(),
    pointsEarned: totalPoints + pointsEarned,
    startedAt: startDate,
  );
  
  // 3. Atualiza pontos do usuário
  userProvider.addPoints(pointsEarned);
  
  // 4. Verifica conquistas
  checkBadges(userId);
}
```

## Estrutura de Pastas Recomendada

```
lib/
├── data/
│   ├── trails/
│   │   ├── foundation_trails.dart
│   │   └── professional_trails.dart
│   ├── lessons/
│   │   ├── literacy_lessons.dart
│   │   ├── math_lessons.dart
│   │   └── ...
│   └── jobs/
│       └── mock_jobs.dart
├── services/
│   ├── lesson_service.dart
│   ├── progress_service.dart
│   ├── badge_service.dart
│   └── job_matching_service.dart
└── ... (estrutura existente)
```

## Exemplo Completo: Adicionando Trilha de "Inglês Básico"

### 1. Adicione a categoria

```dart
enum TrailCategory {
  // ...
  basicEnglish,
}
```

### 2. Crie a trilha

```dart
TrailModel(
  id: 'basic_english',
  title: 'Inglês Básico Profissional',
  description: 'Aprenda vocabulário e frases essenciais para o ambiente de trabalho',
  type: TrailType.professional,
  category: TrailCategory.basicEnglish,
  iconPath: '',
  totalLessons: 20,
  estimatedHours: 12,
  lessonIds: ['eng_1', 'eng_2', '...'],
  requiredLevel: 2,
)
```

### 3. Crie as lições

```dart
// Lição 1
LessonModel(
  id: 'eng_1',
  trailId: 'basic_english',
  title: 'Apresentações Profissionais',
  description: 'Como se apresentar em inglês',
  type: LessonType.theory,
  difficulty: DifficultyLevel.easy,
  pointsReward: 10,
  estimatedMinutes: 15,
  order: 1,
  contentBlocks: [
    ContentBlock(
      type: 'text',
      content: '''
# Apresentações em Inglês

Frases essenciais:
- "Hello, my name is..."
- "I work at..."
- "Nice to meet you"
      ''',
    ),
    ContentBlock(
      type: 'example',
      content: '''
Exemplo de apresentação:
"Hello, my name is João Silva. 
I work at Tech Company as an assistant. 
Nice to meet you!"
      ''',
    ),
  ],
  questions: [
    Question(
      id: 'eng_1_q1',
      text: 'Como você diz "Prazer em conhecê-lo" em inglês?',
      correctAnswerId: 'a1',
      explanation: 'Nice to meet you é a forma mais comum',
      points: 5,
      answers: [
        Answer(id: 'a1', text: 'Nice to meet you'),
        Answer(id: 'a2', text: 'Good morning'),
        Answer(id: 'a3', text: 'How are you'),
        Answer(id: 'a4', text: 'Thank you'),
      ],
    ),
  ],
)
```

## Dicas de Conteúdo

### Para Lições de Teoria
- Use linguagem simples e direta
- Divida em blocos pequenos
- Adicione exemplos práticos
- Use analogias do dia a dia

### Para Lições de Prática
- Cenários reais do trabalho
- Problemas contextualizados
- Múltiplas formas de resolver

### Para Quiz
- Perguntas objetivas e claras
- 4 alternativas
- Explicação da resposta correta
- Dificuldade progressiva

### Para Desafios
- Tempo limitado (opcional)
- Conteúdo revisional
- Recompensa atrativa
- Variedade de temas

---

**Lembre-se**: Todo conteúdo deve ser:
- ✅ Acessível (linguagem simples)
- ✅ Prático (aplicável no trabalho)
- ✅ Modular (pode ser feito em partes)
- ✅ Progressivo (do fácil ao difícil)
- ✅ Motivador (gamificado e recompensador)
