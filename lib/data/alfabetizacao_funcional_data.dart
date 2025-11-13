import '../models/lesson_model.dart';
import '../models/trail_model.dart';

class AlfabetizacaoFuncionalData {
  static TrailModel getTrail() {
    final lessons = getLessons();
    return TrailModel(
      id: 'alfabetizacao_funcional',
      title: 'Alfabetização Funcional',
      description:
          'Compreensão prática do mundo real através da leitura e escrita aplicada ao cotidiano profissional.',
      type: TrailType.foundation,
      category: TrailCategory.functionalLiteracy,
      iconPath: '📖',
      totalLessons: 10,
      estimatedHours: 8,
      lessonIds: lessons.map((l) => l.id).toList(),
      requiredLevel: 1,
    );
  }

  static List<LessonModel> getLessons() {
    return [
      // Lição 1
      LessonModel(
        id: 'af_l1',
        trailId: 'alfabetizacao_funcional',
        title: 'O que é alfabetização funcional',
        description:
            'Entenda o conceito e sua importância para o ambiente de trabalho e a vida cotidiana.',
        type: LessonType.theory,
        difficulty: DifficultyLevel.easy,
        pointsReward: 40,
        estimatedMinutes: 30,
        order: 1,
        contentBlocks: [
          ContentBlock(
            type: 'text',
            content: '''
# Alfabetização Funcional

A alfabetização funcional vai além de saber ler e escrever. É a capacidade de usar essas habilidades em situações reais do dia a dia, especialmente no trabalho.

## Por que é importante?

No ambiente profissional, você precisa:
- Ler e entender e-mails e mensagens
- Interpretar instruções e procedimentos
- Preencher formulários corretamente
- Comunicar-se de forma clara

## Diferença entre alfabetização básica e funcional

**Alfabetização Básica:** Saber ler e escrever palavras e frases simples.

**Alfabetização Funcional:** Usar leitura e escrita para resolver problemas reais, tomar decisões e se comunicar no trabalho e na vida.
''',
          ),
        ],
        questions: [
          Question(
            id: 'af_l1_q1',
            text: 'O que significa ser funcionalmente alfabetizado?',
            answers: [
              Answer(id: 'a', text: 'Saber ler e escrever textos complexos'),
              Answer(
                  id: 'b',
                  text:
                      'Ser capaz de ler, compreender e usar informações em situações reais do dia a dia'),
              Answer(
                  id: 'c', text: 'Decorar regras gramaticais e ortográficas'),
              Answer(id: 'd', text: 'Ler textos técnicos de engenharia'),
            ],
            correctAnswerId: 'b',
            points: 10,
            explanation:
                'Alfabetização funcional é a capacidade de aplicar leitura e escrita em situações práticas do cotidiano profissional e pessoal.',
          ),
        ],
      ),

      // Lição 2
      LessonModel(
        id: 'af_l2',
        trailId: 'alfabetizacao_funcional',
        title: 'Leitura e interpretação de textos curtos',
        description:
            'Aprenda a identificar informações principais em bilhetes, avisos e mensagens simples.',
        type: LessonType.practice,
        difficulty: DifficultyLevel.easy,
        pointsReward: 60,
        estimatedMinutes: 40,
        order: 2,
        contentBlocks: [
          ContentBlock(
            type: 'text',
            content: '''
# Lendo Textos Curtos

Mensagens curtas são comuns no trabalho: avisos, bilhetes, mensagens rápidas.

## Como identificar o essencial?

1. **Quem** está falando
2. **O que** precisa ser feito
3. **Quando** deve ser feito
4. **Onde** acontecerá

## Exemplo:
"AVISO: A reunião começará às 9h. Tragam seus relatórios atualizados."

- **O que:** Reunião
- **Quando:** 9h
- **O que trazer:** Relatórios atualizados
''',
          ),
        ],
        questions: [
          Question(
            id: 'af_l2_q1',
            text:
                'Leia o aviso: "AVISO: A reunião começará às 9h. Tragam seus relatórios atualizados."\n\nQual é a principal instrução deste aviso?',
            answers: [
              Answer(id: 'a', text: 'Chegar pontualmente'),
              Answer(
                  id: 'b',
                  text:
                      'Trazer os relatórios atualizados para a reunião das 9h'),
              Answer(
                  id: 'c',
                  text: 'Atualizar os relatórios depois da reunião'),
              Answer(id: 'd', text: 'Enviar relatórios por e-mail'),
            ],
            correctAnswerId: 'b',
            points: 15,
            explanation:
                'O aviso pede duas coisas: comparecer à reunião às 9h E trazer relatórios atualizados.',
          ),
          Question(
            id: 'af_l2_q2',
            text: 'A reunião acontecerá às 10h.',
            answers: [
              Answer(id: 'false', text: 'Falso'),
              Answer(id: 'true', text: 'Verdadeiro'),
            ],
            correctAnswerId: 'false',
            points: 5,
            explanation:
                'Falso. O aviso diz claramente que a reunião começará às 9h.',
          ),
        ],
      ),

      // Lição 3
      LessonModel(
        id: 'af_l3',
        trailId: 'alfabetizacao_funcional',
        title: 'Compreensão de instruções e formulários',
        description:
            'Exercite a leitura de instruções simples e o preenchimento de formulários profissionais.',
        type: LessonType.practice,
        difficulty: DifficultyLevel.medium,
        pointsReward: 70,
        estimatedMinutes: 45,
        order: 3,
        contentBlocks: [
          ContentBlock(
            type: 'text',
            content: '''
# Instruções e Formulários

Formulários fazem parte da rotina profissional. Saber preenchê-los corretamente evita erros e retrabalho.

## Dicas importantes:

1. **Leia tudo antes** de começar a preencher
2. **Atenção aos campos obrigatórios** (geralmente marcados com *)
3. **Use letra legível** ou digite com cuidado
4. **Revise antes de enviar**

## Campos comuns:
- Nome completo (sem abreviações)
- CPF (11 dígitos, sem pontos ou traços)
- Data de nascimento (formato DD/MM/AAAA)
- E-mail (verifique se digitou corretamente)
''',
          ),
        ],
        questions: [
          Question(
            id: 'af_l3_q1',
            text:
                'Leia a instrução: "Preencha seu nome completo e número de documento antes de enviar o formulário."\n\nO que o texto pede para ser feito?',
            answers: [
              Answer(id: 'a', text: 'Enviar o formulário em branco'),
              Answer(id: 'b', text: 'Preencher apenas o nome'),
              Answer(
                  id: 'c',
                  text:
                      'Preencher nome completo e número de documento antes de enviar'),
              Answer(id: 'd', text: 'Assinar o formulário'),
            ],
            correctAnswerId: 'c',
            points: 15,
            explanation:
                'A instrução é clara: preencher nome completo E número de documento ANTES de enviar.',
          ),
        ],
      ),

      // Lição 4
      LessonModel(
        id: 'af_l4',
        trailId: 'alfabetizacao_funcional',
        title: 'Leitura aplicada ao cotidiano profissional',
        description:
            'Aprenda a interpretar e-mails, comunicados e mensagens internas de trabalho.',
        type: LessonType.practice,
        difficulty: DifficultyLevel.medium,
        pointsReward: 80,
        estimatedMinutes: 50,
        order: 4,
        contentBlocks: [
          ContentBlock(
            type: 'text',
            content: '''
# E-mails Profissionais

E-mails são a principal forma de comunicação no trabalho. Saber interpretá-los corretamente é essencial.

## Estrutura de um e-mail:
1. **Assunto:** Resumo do conteúdo
2. **Saudação:** "Bom dia", "Olá"
3. **Corpo:** A mensagem principal
4. **Despedida:** "Atenciosamente", "Abraços"

## O que observar:
- Quem enviou
- Para quem foi enviado
- O que está sendo pedido
- Qual é o prazo
- Se precisa responder

## Exemplo:
"Bom dia! O cliente pediu a atualização da planilha até as 14h. Confirme quando enviar."

**Ação necessária:** Atualizar planilha + Avisar quando enviar + Prazo: 14h
''',
          ),
        ],
        questions: [
          Question(
            id: 'af_l4_q1',
            text:
                'E-mail: "Bom dia! O cliente pediu a atualização da planilha até as 14h. Confirme quando enviar."\n\nO que deve ser feito segundo o e-mail?',
            answers: [
              Answer(id: 'a', text: 'Apenas atualizar a planilha'),
              Answer(
                  id: 'b',
                  text: 'Atualizar a planilha e avisar quando for enviada'),
              Answer(id: 'c', text: 'Enviar a planilha sem atualizar'),
              Answer(
                  id: 'd',
                  text: 'Responder o e-mail dizendo que não é possível'),
            ],
            correctAnswerId: 'b',
            points: 20,
            explanation:
                'O e-mail pede duas ações: 1) Atualizar a planilha até 14h, 2) Confirmar/avisar quando enviar.',
          ),
        ],
      ),

      // Lição 5
      LessonModel(
        id: 'af_l5',
        trailId: 'alfabetizacao_funcional',
        title: 'Identificando informações principais',
        description:
            'Pratique como reconhecer ideias centrais em pequenos textos e anúncios.',
        type: LessonType.quiz,
        difficulty: DifficultyLevel.medium,
        pointsReward: 70,
        estimatedMinutes: 35,
        order: 5,
        contentBlocks: [
          ContentBlock(
            type: 'text',
            content: '''
# Identificando o Essencial

Nem tudo em um texto é igualmente importante. Aprenda a filtrar o essencial.

## Perguntas-chave:
- **O QUÊ?** - Qual é a informação principal?
- **QUANDO?** - Há um prazo ou horário?
- **ONDE?** - Há um local específico?
- **QUEM?** - Quem está envolvido?

## Técnica: Sublinhar ou destacar
Ao ler, marque mentalmente as palavras mais importantes:
- Datas e horários
- Números e valores
- Ações (verbos: fazer, enviar, comparecer)
''',
          ),
        ],
        questions: [
          Question(
            id: 'af_l5_q1',
            text:
                'Em um aviso que diz "Entrega de uniformes amanhã das 10h às 12h", qual é a informação principal?',
            answers: [
              Answer(id: 'a', text: 'Os uniformes estão prontos'),
              Answer(
                  id: 'b',
                  text: 'As entregas acontecem amanhã das 10h às 12h'),
              Answer(
                  id: 'c',
                  text: 'Os funcionários devem ir à empresa à tarde'),
              Answer(
                  id: 'd',
                  text:
                      'Os uniformes serão entregues pela manhã, sem horário definido'),
            ],
            correctAnswerId: 'b',
            points: 10,
            explanation:
                'A informação mais importante é QUANDO acontecerá: amanhã, das 10h às 12h.',
          ),
        ],
      ),

      // Lição 6
      LessonModel(
        id: 'af_l6',
        trailId: 'alfabetizacao_funcional',
        title: 'Comunicados e cartazes públicos',
        description:
            'Aprenda a extrair informações úteis de textos visuais e comunicados oficiais.',
        type: LessonType.practice,
        difficulty: DifficultyLevel.medium,
        pointsReward: 60,
        estimatedMinutes: 40,
        order: 6,
        contentBlocks: [
          ContentBlock(
            type: 'text',
            content: '''
# Avisos e Cartazes

Avisos rápidos comunicam informações importantes de forma direta.

## Características:
- Texto curto e objetivo
- Mensagem clara
- Chamada à atenção (cores, palavras em destaque)

## Tipos comuns:
- **Segurança:** "CUIDADO: Piso molhado"
- **Orientação:** "Use máscara"
- **Informação:** "Reunião cancelada"

## Como ler:
1. Leia a palavra em destaque primeiro
2. Entenda o contexto
3. Identifique a ação necessária
''',
          ),
        ],
        questions: [
          Question(
            id: 'af_l6_q1',
            text:
                'Aviso: "CUIDADO: Piso molhado. Evite acidentes."\n\nO que o aviso tenta evitar?',
            answers: [
              Answer(id: 'a', text: 'Que as pessoas molhem o piso'),
              Answer(
                  id: 'b', text: 'Acidentes causados por piso molhado'),
              Answer(id: 'c', text: 'Que as pessoas usem o elevador'),
              Answer(id: 'd', text: 'Que as pessoas corram'),
            ],
            correctAnswerId: 'b',
            points: 15,
            explanation:
                'O aviso alerta sobre o piso molhado para evitar que pessoas escorreguem e se machuquem.',
          ),
        ],
      ),

      // Lição 7
      LessonModel(
        id: 'af_l7',
        trailId: 'alfabetizacao_funcional',
        title: 'Vocabulário prático do dia a dia',
        description: 'Expanda o vocabulário usado em ambientes profissionais.',
        type: LessonType.theory,
        difficulty: DifficultyLevel.medium,
        pointsReward: 80,
        estimatedMinutes: 45,
        order: 7,
        contentBlocks: [
          ContentBlock(
            type: 'text',
            content: '''
# Vocabulário Profissional

Conhecer os termos mais usados no trabalho facilita a comunicação.

## Palavras-chave:

**Reunião:** Encontro para discutir assuntos de trabalho

**Relatório:** Documento com informações e resultados de um projeto ou atividade

**Prazo:** Data limite para entrega de algo

**Demanda:** Solicitação, pedido de trabalho

**Feedback:** Retorno, comentário sobre algo feito

**Protocolo:** Número de registro de um documento ou solicitação

**Pendência:** Algo que ainda precisa ser resolvido

**Cronograma:** Planejamento com datas e etapas
''',
          ),
        ],
        questions: [
          Question(
            id: 'af_l7_q1',
            text: 'Qual é o significado de "Prazo"?',
            answers: [
              Answer(id: 'a', text: 'Documento com informações'),
              Answer(id: 'b', text: 'Data limite para entrega'),
              Answer(id: 'c', text: 'Encontro para discutir assuntos'),
              Answer(id: 'd', text: 'Solicitação de trabalho'),
            ],
            correctAnswerId: 'b',
            points: 10,
            explanation:
                'Prazo é a data limite até quando algo deve ser entregue ou finalizado.',
          ),
          Question(
            id: 'af_l7_q2',
            text: 'O que significa "Relatório"?',
            answers: [
              Answer(id: 'a', text: 'Reunião de trabalho'),
              Answer(id: 'b', text: 'Data de entrega'),
              Answer(
                  id: 'c',
                  text: 'Documento com informações e resultados'),
              Answer(id: 'd', text: 'Número de registro'),
            ],
            correctAnswerId: 'c',
            points: 10,
            explanation:
                'Relatório é um documento que apresenta informações, dados e resultados sobre um projeto ou atividade.',
          ),
        ],
      ),

      // Lição 8
      LessonModel(
        id: 'af_l8',
        trailId: 'alfabetizacao_funcional',
        title: 'Leitura crítica e tomada de decisão',
        description:
            'Exercite a análise de mensagens e notícias para decidir ações corretas.',
        type: LessonType.challenge,
        difficulty: DifficultyLevel.medium,
        pointsReward: 90,
        estimatedMinutes: 50,
        order: 8,
        contentBlocks: [
          ContentBlock(
            type: 'text',
            content: '''
# Leitura Crítica

Ler criticamente significa entender não apenas o que está escrito, mas também o que deve ser feito.

## Passos para análise:
1. Ler com atenção
2. Identificar informações-chave
3. Entender o contexto
4. Decidir a melhor ação

## Exemplo:
Mensagem: "O chefe pediu prioridade para o projeto B, o projeto A pode ser enviado até amanhã."

**Análise:**
- Prioridade = Projeto B (fazer primeiro)
- Projeto A = Pode esperar até amanhã
- **Ação:** Focar no projeto B agora
''',
          ),
        ],
        questions: [
          Question(
            id: 'af_l8_q1',
            text:
                'Mensagem: "O chefe pediu prioridade para o projeto B, o projeto A pode ser enviado até amanhã."\n\nQual deve ser a ação mais adequada?',
            answers: [
              Answer(id: 'a', text: 'Trabalhar primeiro no projeto A'),
              Answer(id: 'b', text: 'Focar no projeto B, pois é prioridade'),
              Answer(id: 'c', text: 'Esperar novas instruções'),
              Answer(id: 'd', text: 'Enviar ambos agora'),
            ],
            correctAnswerId: 'b',
            points: 25,
            explanation:
                'A mensagem deixa claro que o projeto B é prioridade, então deve ser feito primeiro.',
          ),
        ],
      ),

      // Lição 9
      LessonModel(
        id: 'af_l9',
        trailId: 'alfabetizacao_funcional',
        title: 'Erros comuns de comunicação escrita',
        description:
            'Identifique e corrija erros que podem gerar confusões no trabalho.',
        type: LessonType.practice,
        difficulty: DifficultyLevel.hard,
        pointsReward: 70,
        estimatedMinutes: 40,
        order: 9,
        contentBlocks: [
          ContentBlock(
            type: 'text',
            content: '''
# Erros Comuns na Escrita

Pequenos erros podem mudar o sentido de uma mensagem.

## Erros frequentes:

**1. Concordância verbal:**
❌ "O cliente vai vim amanhã"
✅ "O cliente vai vir amanhã"

**2. Uso de "a" ou "há":**
❌ "A empresa existe a 10 anos"
✅ "A empresa existe há 10 anos"

**3. "Mais" ou "Mas":**
❌ "Tentei, más não consegui"
✅ "Tentei, mas não consegui"

**4. Vírgulas importantes:**
❌ "Vamos comer, João!"
✅ "Vamos comer João!" (mudou o sentido!)

## Dica:
Releia sempre antes de enviar!
''',
          ),
        ],
        questions: [
          Question(
            id: 'af_l9_q1',
            text: 'Qual frase está correta?',
            answers: [
              Answer(id: 'a', text: 'O cliente vai vim amanhã'),
              Answer(id: 'b', text: 'O cliente vai vir amanhã'),
              Answer(id: 'c', text: 'O cliente vão vir amanhã'),
              Answer(id: 'd', text: 'O cliente vai vindo amanhã'),
            ],
            correctAnswerId: 'b',
            points: 15,
            explanation:
                'A forma correta é "vai vir" - o verbo "ir" conjugado com o infinitivo "vir".',
          ),
        ],
      ),

      // Lição 10
      LessonModel(
        id: 'af_l10',
        trailId: 'alfabetizacao_funcional',
        title: 'Síntese de informações',
        description: 'Aprenda a resumir textos de maneira objetiva e clara.',
        type: LessonType.challenge,
        difficulty: DifficultyLevel.hard,
        pointsReward: 100,
        estimatedMinutes: 60,
        order: 10,
        contentBlocks: [
          ContentBlock(
            type: 'text',
            content: '''
# Resumindo Informações

Resumir é uma habilidade essencial no trabalho. Você precisa comunicar informações de forma rápida e clara.

## Como fazer um bom resumo:

1. **Leia o texto completo**
2. **Identifique as ideias principais**
3. **Elimine detalhes secundários**
4. **Reescreva com suas palavras de forma objetiva**

## Exemplo:
**Texto original:**
"Reunião marcada para quinta às 15h para discutir melhorias no atendimento. Todos devem levar sugestões por escrito."

**Resumo:**
"Reunião quinta 15h sobre melhorias no atendimento. Trazer sugestões escritas."

## Regras de ouro:
- Mantenha as informações essenciais (quando, onde, o quê)
- Use frases curtas
- Seja direto ao ponto
''',
          ),
        ],
        questions: [
          Question(
            id: 'af_l10_q1',
            text:
                'Texto: "Reunião marcada para quinta às 15h para discutir melhorias no atendimento. Todos devem levar sugestões."\n\nQual é o melhor resumo?',
            answers: [
              Answer(id: 'a', text: 'Reunião quinta'),
              Answer(
                  id: 'b',
                  text: 'Reunião quinta às 15h sobre melhorias no atendimento'),
              Answer(
                  id: 'c',
                  text: 'Todos devem levar sugestões para a reunião'),
              Answer(id: 'd', text: 'Discussão sobre melhorias'),
            ],
            correctAnswerId: 'b',
            points: 25,
            explanation:
                'O resumo ideal mantém as informações essenciais: quando (quinta 15h) e sobre o quê (melhorias no atendimento).',
          ),
        ],
      ),
    ];
  }
}
