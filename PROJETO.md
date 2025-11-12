# IniciApp 📚

Aplicativo educacional gamificado para profissionalização básica de jovens de 14 a 25 anos.

## 🎯 Objetivo

Ensinar habilidades mínimas exigidas pelo mercado de trabalho (tanto cognitivas quanto comportamentais) de forma acessível, rápida, modular, gamificada e direcionada para empregabilidade.

## ✨ Funcionalidades Principais

### 1. Trilhas de Formação
- **Alfabetização Funcional**: Entendimento prático do mundo real
- **Interpretação de Texto**: Leitura crítica e compreensão
- **Raciocínio Lógico**: Pensamento analítico
- **Matemática Aplicada**: Cálculos do cotidiano profissional

### 2. Trilhas Profissionais
- **Escrita Profissional**: E-mail e WhatsApp corporativo
- **Comunicação Assertiva**: Comunicação efetiva
- **Atendimento ao Cliente**: Excelência no atendimento
- **Ética**: Princípios éticos profissionais
- **Postura Comportamental**: Comportamento empresarial
- **Priorização**: Tomada de decisão
- **Resolução de Problemas**: Metodologias práticas
- **Gestão de Conflitos**: Mediação e resolução

### 3. Sistema de Gamificação 🎮
- Sistema de níveis progressivos
- Pontos e recompensas (XP)
- Streak de dias consecutivos
- Desafios diários
- Sistema de ranking
- Badges e conquistas

### 4. Métricas Internas 📊
O app monitora:
- Performance por tema
- Tempo médio de resposta
- Domínio de habilidades
- Velocidade cognitiva
- Soft skills interpretadas

**Ao final**: Recomendação de áreas compatíveis (Admin / Vendas / Atendimento / Tecnologia / etc)

### 5. Aba de Vagas 💼
- Match inteligente baseado no perfil do usuário
- Vagas de nível inicial (sem exigência de ensino superior)
- Cruzamento: perfil + trilha concluída + habilidades
- Geração automática de currículo baseado no progresso
- Candidatura direta

### 6. Certificação Interna 🏆
- Certificados próprios por trilha concluída
- Qualificação complementar reconhecida
- Diferencial de soft skills
- Validação por empresas parceiras (B2B)

## 🎨 Design System

### Cores
- **Principal**: Roxo `#452a84`
- **Secundária**: Amarelo `#F7C800`
- **Acento**: Laranja `#F25C05` (gamificação/conquistas)

### Tipografia
- **Fonte**: Inter (via Google Fonts)

## 🏗️ Arquitetura do Projeto

```
lib/
├── core/
│   ├── constants/
│   │   └── app_constants.dart
│   └── theme/
│       ├── app_colors.dart
│       └── app_theme.dart
├── models/
│   ├── user_model.dart
│   ├── trail_model.dart
│   ├── lesson_model.dart
│   ├── progress_model.dart
│   └── job_model.dart
├── providers/
│   └── user_provider.dart
├── screens/
│   ├── home/
│   │   └── home_screen.dart
│   ├── trails/
│   │   └── trails_screen.dart
│   └── jobs/
│       └── jobs_screen.dart
├── widgets/
│   ├── level_progress_card.dart
│   ├── streak_card.dart
│   └── daily_challenge_card.dart
└── main.dart
```

## 🚀 Como Executar

### Pré-requisitos
- Flutter SDK (>=3.9.2)
- Dart SDK
- Android Studio / Xcode (para emuladores)

### Instalação

1. Clone o repositório:
```bash
git clone <repository-url>
cd iniciapp
```

2. Instale as dependências:
```bash
flutter pub get
```

3. Execute o app:
```bash
flutter run
```

## 📦 Dependências Principais

- `provider`: Gerenciamento de estado
- `google_fonts`: Fonte Inter
- `shared_preferences`: Armazenamento local
- `sqflite`: Banco de dados local
- `fl_chart`: Gráficos e estatísticas
- `confetti`: Animações de conquistas
- `http`: Requisições de rede

## 🎯 Público-Alvo

Jovens de **14 a 25 anos** que buscam:
- Primeira oportunidade de emprego
- Desenvolvimento de habilidades básicas
- Profissionalização sem ensino superior
- Transição para o mercado de trabalho

## 📈 Próximos Passos

- [ ] Implementar tela de ranking
- [ ] Implementar tela de perfil do usuário
- [ ] Criar sistema de lições completo
- [ ] Adicionar quiz interativo
- [ ] Implementar sistema de badges
- [ ] Integração com backend
- [ ] Sistema de autenticação
- [ ] Match de vagas com IA
- [ ] Gerador de currículo automático
- [ ] Sistema de certificados
- [ ] Integração com empresas parceiras

## 📄 Licença

Este projeto está em desenvolvimento.

## 👥 Contribuindo

Contribuições são bem-vindas! Por favor, siga as melhores práticas do Flutter e mantenha o código limpo e documentado.
