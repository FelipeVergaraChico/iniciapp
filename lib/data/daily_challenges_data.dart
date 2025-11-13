import '../models/daily_challenge_model.dart';

class DailyChallengesData {
  static List<DailyChallenge> getAllChallenges() {
    return [
      _getDay1Challenge(),
      _getDay2Challenge(),
      _getDay3Challenge(),
      _getDay4Challenge(),
      _getDay5Challenge(),
    ];
  }

  static DailyChallenge getChallengeForDay(int day) {
    final challenges = getAllChallenges();
    return challenges.firstWhere(
      (c) => c.dayNumber == day,
      orElse: () => challenges[0],
    );
  }

  // 📅 Dia 1 – Comunicação Profissional e Interpretação
  static DailyChallenge _getDay1Challenge() {
    return DailyChallenge(
      id: 'day_1',
      dayNumber: 1,
      title: 'Comunicação Profissional e Interpretação',
      description: 'Pratique comunicação profissional e interpretação de texto',
      questions: [
        // 🟢 Básico - E-mail correto
        ChallengeQuestion(
          id: 'd1_q1',
          text: 'Qual é a forma mais profissional de iniciar um e-mail?',
          type: QuestionType.multipleChoice,
          difficulty: DifficultyTag.basic,
          points: 8,
          options: [
            'a) "Fala aí!"',
            'b) "Bom dia, tudo bem?"',
            'c) "E aí galera?"',
          ],
          correctOption: 'b',
          explanation: 'A saudação "Bom dia, tudo bem?" é cordial e profissional, adequada para o ambiente corporativo.',
        ),
        // 🟣 Mediano - Interpretação contextual
        ChallengeQuestion(
          id: 'd1_q2',
          text: 'O comportamento de Carla demonstra qual habilidade profissional?',
          type: QuestionType.multipleChoice,
          difficulty: DifficultyTag.medium,
          points: 100,
          context: 'Durante a reunião, Carla percebeu que seu colega havia cometido um erro nos dados, mas decidiu falar com ele após o término, em particular.',
          options: [
            'a) Assertividade e respeito',
            'b) Falta de iniciativa',
            'c) Postura autoritária',
          ],
          correctOption: 'a',
          explanation: 'Carla demonstrou assertividade ao identificar o erro e respeito ao escolher abordá-lo em particular, evitando constrangimento público.',
          skillTag: 'Comunicação ética e empática',
        ),
        // 🟢 Básico - Ortografia profissional
        ChallengeQuestion(
          id: 'd1_q3',
          text: 'Qual das opções está escrita corretamente?',
          type: QuestionType.multipleChoice,
          difficulty: DifficultyTag.basic,
          points: 7,
          options: [
            'a) "Prezada cliente, segue o orçamento conforme combinado."',
            'b) "Prezada cliente, segue o orçamente conforme combinadu."',
          ],
          correctOption: 'a',
          explanation: 'A opção A está escrita corretamente, com ortografia adequada de "orçamento" e "combinado".',
        ),
      ],
      bonusPoints: 5,
    );
  }

  // 📅 Dia 2 – Matemática Aplicada + Tomada de Decisão
  static DailyChallenge _getDay2Challenge() {
    return DailyChallenge(
      id: 'day_2',
      dayNumber: 2,
      title: 'Matemática Aplicada + Tomada de Decisão',
      description: 'Resolva problemas matemáticos e pratique priorização',
      questions: [
        // 🟢 Básico - Porcentagem simples
        ChallengeQuestion(
          id: 'd2_q1',
          text: 'Um produto custa R\$ 200 e tem 25% de desconto. Qual o valor final?',
          type: QuestionType.numericInput,
          difficulty: DifficultyTag.basic,
          points: 100,
          correctAnswer: '150',
          explanation: 'Desconto: 200 × 0,25 = 50. Valor final: 200 - 50 = R\$ 150',
        ),
        // 🟣 Mediano - Cálculo com contexto profissional
        ChallengeQuestion(
          id: 'd2_q2',
          text: 'Se usar 2 impressoras ao mesmo tempo, quanto tempo levará?',
          type: QuestionType.multipleChoice,
          difficulty: DifficultyTag.medium,
          points: 20,
          context: 'Você é assistente administrativo e precisa imprimir 1.200 páginas. Cada impressora imprime 40 páginas por minuto.',
          options: [
            'a) 15 minutos',
            'b) 30 minutos',
            'c) 20 minutos',
            'd) 10 minutos',
          ],
          correctOption: 'a',
          explanation: '1.200 ÷ (40 × 2) = 1.200 ÷ 80 = 15 minutos',
          skillTag: 'Raciocínio lógico e proporcionalidade',
        ),
        // 🟣 Mediano - Tomada de decisão
        ChallengeQuestion(
          id: 'd2_q3',
          text: 'Qual tarefa deve vir primeiro?',
          type: QuestionType.multipleChoice,
          difficulty: DifficultyTag.medium,
          points: 15,
          context: 'Você tem 3 tarefas:\n1️⃣ Responder um cliente irritado.\n2️⃣ Entregar relatório em 30 minutos.\n3️⃣ Revisar planilha sem prazo definido.',
          options: [
            'a) Responder o cliente irritado',
            'b) Entregar o relatório',
            'c) Revisar a planilha',
          ],
          correctOption: 'b',
          explanation: 'O relatório tem prazo fixo e urgente (30 min). Após entregar, pode atender o cliente e depois revisar a planilha.',
          skillTag: 'Priorização sob pressão',
        ),
      ],
      bonusPoints: 5,
    );
  }

  // 📅 Dia 3 – Ética, Atendimento e Resolução de Problemas
  static DailyChallenge _getDay3Challenge() {
    return DailyChallenge(
      id: 'day_3',
      dayNumber: 3,
      title: 'Ética, Atendimento e Resolução de Problemas',
      description: 'Desenvolva ética profissional e habilidades de atendimento',
      questions: [
        // 🟣 Mediano - Dilema ético
        ChallengeQuestion(
          id: 'd3_q1',
          text: 'O que você faz?',
          type: QuestionType.multipleChoice,
          difficulty: DifficultyTag.medium,
          points: 20,
          context: 'Um colega pede que você assine um documento "só pra agilizar", mesmo sem ter revisado.',
          options: [
            'a) Assina, pra não causar atraso',
            'b) Se recusa e informa que só assinará após ler',
            'c) Delega pra outro colega',
          ],
          correctOption: 'b',
          explanation: 'Assinar sem revisar pode gerar problemas legais e éticos. Sempre revise antes de assinar.',
          skillTag: 'Integridade e responsabilidade',
        ),
        // 🟢 Básico - Atendimento ao cliente
        ChallengeQuestion(
          id: 'd3_q2',
          text: 'Cliente: "Fiz o pedido errado. E agora?"',
          type: QuestionType.multipleChoice,
          difficulty: DifficultyTag.basic,
          points: 15,
          options: [
            'a) "Não posso fazer nada."',
            'b) "Entendo, posso te ajudar a alterar o pedido."',
            'c) "Foi erro seu, não meu."',
          ],
          correctOption: 'b',
          explanation: 'Demonstrar empatia e oferecer solução é essencial no atendimento ao cliente.',
        ),
        // 🟣 Mediano - Resolução prática
        ChallengeQuestion(
          id: 'd3_q3',
          text: 'O caixa do supermercado parou de funcionar. O que é mais eficiente fazer?',
          type: QuestionType.multipleChoice,
          difficulty: DifficultyTag.medium,
          points: 100,
          options: [
            'a) Esperar o técnico chegar sem agir',
            'b) Avisar os clientes e direcionar para outro caixa',
            'c) Sair do posto para tomar café',
          ],
          correctOption: 'b',
          explanation: 'A proatividade de avisar e direcionar clientes minimiza impactos e demonstra responsabilidade.',
          skillTag: 'Proatividade e comunicação rápida',
        ),
      ],
      bonusPoints: 5,
    );
  }

  // 📅 Dia 4 – Raciocínio Lógico e Comunicação
  static DailyChallenge _getDay4Challenge() {
    return DailyChallenge(
      id: 'day_4',
      dayNumber: 4,
      title: 'Raciocínio Lógico e Comunicação',
      description: 'Exercite lógica e interpretação corporativa',
      questions: [
        // 🟢 Básico - Sequência numérica
        ChallengeQuestion(
          id: 'd4_q1',
          text: 'Complete a sequência: 2, 4, 8, 16, ___',
          type: QuestionType.numericInput,
          difficulty: DifficultyTag.basic,
          points: 8,
          correctAnswer: '32',
          explanation: 'A sequência multiplica por 2 a cada passo: 2, 4, 8, 16, 32...',
        ),
        // 🟣 Mediano - Lógica de padrões
        ChallengeQuestion(
          id: 'd4_q2',
          text: 'Em 5 viagens completas, com 80% de ocupação, quantas pessoas foram transportadas?',
          type: QuestionType.numericInput,
          difficulty: DifficultyTag.medium,
          points: 20,
          context: 'Um ônibus leva 40 passageiros por viagem.',
          correctAnswer: '160',
          explanation: '40 × 5 × 0,8 = 160 pessoas',
          skillTag: 'Cálculo aplicado',
        ),
        // 🟣 Mediano - Comunicação corporativa
        ChallengeQuestion(
          id: 'd4_q3',
          text: 'O que isso significa em um contexto de trabalho?',
          type: QuestionType.multipleChoice,
          difficulty: DifficultyTag.medium,
          points: 15,
          context: 'Frase: "Vamos reavaliar essa entrega na próxima sprint."',
          options: [
            'a) O projeto foi cancelado',
            'b) A tarefa será adiada para reavaliação futura',
            'c) O projeto foi aprovado',
          ],
          correctOption: 'b',
          explanation: 'Reavaliar na próxima sprint significa que a decisão será postergada para análise posterior.',
          skillTag: 'Interpretação de contexto empresarial',
        ),
      ],
      bonusPoints: 5,
    );
  }

  // 📅 Dia 5 – Desafio Semanal (mistura de tudo)
  static DailyChallenge _getDay5Challenge() {
    return DailyChallenge(
      id: 'day_5',
      dayNumber: 5,
      title: 'Desafio Semanal',
      description: 'Teste completo com todas as habilidades',
      questions: [
        // Texto curto - interpretação
        ChallengeQuestion(
          id: 'd5_q1',
          text: 'Qual atitude demonstra profissionalismo?',
          type: QuestionType.multipleChoice,
          difficulty: DifficultyTag.medium,
          points: 15,
          context: 'O cliente solicitou que o produto fosse entregue antes do prazo, mas o setor de logística informou que seria impossível.',
          options: [
            'a) Explicar o motivo e oferecer alternativas',
            'b) Apenas dizer que não é possível',
            'c) Prometer a entrega sem consultar',
          ],
          correctOption: 'a',
          explanation: 'Explicar o motivo da impossibilidade e oferecer alternativas demonstra transparência e proatividade.',
        ),
        // Cálculo rápido
        ChallengeQuestion(
          id: 'd5_q2',
          text: '15% de 320 = ?',
          type: QuestionType.numericInput,
          difficulty: DifficultyTag.basic,
          points: 10,
          correctAnswer: '48',
          explanation: '320 × 0,15 = 48',
        ),
        // Lógica visual
        ChallengeQuestion(
          id: 'd5_q3',
          text: 'Se cada caixa contém 6 itens e são 7 caixas, quantos itens há?',
          type: QuestionType.numericInput,
          difficulty: DifficultyTag.basic,
          points: 8,
          correctAnswer: '42',
          explanation: '6 × 7 = 42 itens',
        ),
        // Ética digital
        ChallengeQuestion(
          id: 'd5_q4',
          text: 'Um amigo te pede senha do sistema da empresa pra "adiantar o serviço". O que fazer?',
          type: QuestionType.multipleChoice,
          difficulty: DifficultyTag.medium,
          points: 20,
          options: [
            'a) Passar a senha, é só para ajudar',
            'b) Recusar e avisar o supervisor',
            'c) Criar uma senha temporária',
          ],
          correctOption: 'b',
          explanation: 'Compartilhar senhas viola políticas de segurança. Recusar e informar é a conduta correta.',
        ),
        // Frase profissional
        ChallengeQuestion(
          id: 'd5_q5',
          text: 'Reescreva de forma mais adequada: "Vou ver isso depois."',
          type: QuestionType.multipleChoice,
          difficulty: DifficultyTag.basic,
          points: 12,
          options: [
            'a) "Vou ver isso depois."',
            'b) "Posso verificar e te retorno ainda hoje."',
            'c) "Não tenho tempo agora."',
          ],
          correctOption: 'b',
          explanation: 'A resposta B é mais profissional, clara e comprometida com o retorno.',
        ),
      ],
      bonusPoints: 50, // Bônus especial "Aprendiz Produtivo da Semana"
    );
  }
}
