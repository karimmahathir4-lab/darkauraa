import 'package:flutter/material.dart';

class AuraLocalizations {
  const AuraLocalizations(this.locale);
  final Locale locale;
  static const supportedLocales = <Locale>[
    Locale('en', 'US'),
    Locale('pt', 'BR'),
    Locale('es', 'ES'),
    Locale('ar', 'SA')
  ];
  static const delegate = _AuraLocalizationsDelegate();
  static AuraLocalizations of(BuildContext context) =>
      Localizations.of<AuraLocalizations>(context, AuraLocalizations)!;
  String text(String source) =>
      _translations[locale.languageCode]?[source] ?? source;

  String lessonParagraph(String lessonId, int index, String fallback) =>
      _lessonTranslations[locale.languageCode]?["$lessonId:$index"] ?? fallback;
}

extension AuraTranslate on BuildContext {
  String tr(String source) => AuraLocalizations.of(this).text(source);
  String lessonParagraph(String id, int index, String fallback) =>
      AuraLocalizations.of(this).lessonParagraph(id, index, fallback);
}

class _AuraLocalizationsDelegate
    extends LocalizationsDelegate<AuraLocalizations> {
  const _AuraLocalizationsDelegate();
  @override
  bool isSupported(Locale locale) => AuraLocalizations.supportedLocales
      .any((item) => item.languageCode == locale.languageCode);
  @override
  Future<AuraLocalizations> load(Locale locale) async =>
      AuraLocalizations(locale);
  @override
  bool shouldReload(_AuraLocalizationsDelegate old) => false;
}

const _translations = <String, Map<String, String>>{
  'pt': {
    'Your checklist, lesson progress, drill scores, and history are stored on this device. Sample device and performance values are made up. The app does not read or change game or phone settings.':
        'Sua lista, progresso das lições, pontuações e histórico ficam salvos neste aparelho. Dados do dispositivo e desempenho são simulados. O app não lê nem altera configurações do jogo ou do celular.',
    'Practice with purpose': 'Treine com intenção',
    'Privacy and control': 'Privacidade e controle',
    'Your progress stays on this device. Nothing in your game or phone is changed.':
        'Seu progresso fica neste aparelho. Nada no jogo ou no celular é alterado.',
    'Rewarded ad feature': 'Recurso com anúncio premiado',
    'Build steadier aim with short drills, progress tracking, and practical lessons.':
        'Melhore a precisão com treinos curtos, acompanhamento do progresso e lições práticas.',
    'Your setup stays yours': 'Sua configuração continua sua',
    'Checklist choices stay in this app. Nothing in your game or phone is changed.':
        'As opções da lista ficam neste app. Nada no jogo ou no celular é alterado.',
    'Ads and your choice': 'Anúncios e sua escolha',
    'Dark Aura uses AppLovin to show ads. If you allow tracking, its ad partners may use identifiers to measure ads and make them more relevant. Ads may still appear if you decline.':
        'Dark Aura usa o AppLovin para exibir anúncios. Se permitir rastreamento, parceiros de anúncios podem usar identificadores para medir anúncios e torná-los mais relevantes. Anúncios ainda podem aparecer se você recusar.',
    'On iPhone and iPad, you can choose whether to allow ad tracking.':
        'No iPhone e iPad, você escolhe se permite o rastreamento para anúncios.',
    'Continue': 'Continuar',
    'Continue without tracking': 'Continuar sem rastreamento',
    'Next': 'Avançar',
    'Skip': 'Pular',
    'Enable with a rewarded ad?': 'Ativar com um anúncio premiado?',
    'Watch a short ad to enable this training option. It turns on only after the reward is confirmed.':
        'Assista a um anúncio curto para ativar esta opção de treino. Ela será ativada após a confirmação da recompensa.',
    'Not now': 'Agora não',
    'Watch ad': 'Assistir anúncio',
    'Feature enabled': 'Recurso ativado',
    'Ad is not ready. Try again soon.':
        'O anúncio não está pronto. Tente novamente em breve.',
    'AppLovin may receive device and ad-interaction data to deliver and measure ads. Your ATT choice controls cross-app tracking on Apple devices. For details about AppLovin’s collection and use of information, visit:':
        'O AppLovin pode receber dados do dispositivo e das interações com anúncios para exibir e medir anúncios. Sua escolha no ATT controla o rastreamento entre apps em dispositivos Apple. Para saber mais sobre a coleta e o uso de informações pelo AppLovin, acesse:',
    'AppLovin Privacy Policy': 'Política de privacidade do AppLovin',
    'Settings': 'Configurações',
    'Privacy Policy': 'Política de Privacidade',
    'How your local app data is handled':
        'Como os dados locais do app são tratados',
    'Share App': 'Compartilhar app',
    'Tell someone about Aura Aim': 'Conte a alguém sobre Aura Aim',
    'Rate App': 'Avaliar app',
    'Open the app store page': 'Abrir a página da loja',
    'Reset all progress': 'Redefinir todo o progresso',
    'Clear scores, lessons, streaks, and toggles':
        'Apagar pontuações, lições, sequências e opções',
    'About': 'Sobre',
    'Version and app details': 'Versão e detalhes do app',
    'Language': 'Idioma',
    'Choose the language used throughout the app':
        'Escolha o idioma usado em todo o app',
    'Reset all progress?': 'Redefinir todo o progresso?',
    'Cancel': 'Cancelar',
    'Reset everything': 'Redefinir tudo',
    'All progress cleared': 'Todo o progresso foi apagado',
    'Your Practice Snapshot': 'Resumo da sua prática',
    'DAILY STREAK': 'SEQUÊNCIA DIÁRIA',
    'DRILLS DONE': 'TREINOS CONCLUÍDOS',
    'LESSONS': 'LIÇÕES',
    'days': 'dias',
    'Practice profile enabled': 'Perfil de prática ativado',
    'Tap to enable practice profile': 'Toque para ativar o perfil de prática',
    'SENSI RESULT': 'RESULTADO DE SENSI',
    'Scale 0 to 200': 'Escala de 0 a 200',
    'GENERATED': 'GERADO',
    'SAMPLE PREVIEW': 'PRÉVIA DE AMOSTRA',
    'Sensitivity Generator (simulated)': 'Gerador de sensibilidade (simulado)',
    'Device type': 'Tipo de dispositivo',
    'Play style': 'Estilo de jogo',
    'Low-end': 'Básico',
    'Mid-range': 'Intermediário',
    'High-end': 'Avançado',
    'Tablet': 'Tablet',
    'Defensive': 'Defensivo',
    'Balanced': 'Equilibrado',
    'Aggressive': 'Agressivo',
    'GENERATE': 'GERAR',
    'GENERATING...': 'GERANDO...',
    'Copy': 'Copiar',
    'Copied simulated values': 'Valores simulados copiados',
    'General': 'Geral',
    'Red Dot': 'Ponto vermelho',
    'Device Info (sample data)':
        'Informações do dispositivo (dados de amostra)',
    'Live Performance (simulated)': 'Desempenho ao vivo (simulado)',
    'iPhone model · choose manually': 'Modelo do iPhone · escolha manualmente',
    'Sample baseline': 'Base de amostra',
    'TRAIN WITH INTENTION': 'TREINE COM INTENÇÃO',
    'Short practice rounds for timing, control, and precision.':
        'Rodadas curtas para treinar tempo, controle e precisão.',
    'Round length': 'Duração da rodada',
    'Easy': 'Fácil',
    'Medium': 'Médio',
    'Hard': 'Difícil',
    'Start': 'Iniciar',
    'Trains': 'Treina',
    'BEST': 'MELHOR',
    'Learning Progress': 'Progresso de aprendizado',
    'lessons complete': 'lições concluídas',
    'Complete': 'Concluída',
    'Key takeaways': 'Principais aprendizados',
    'Try this drill': 'Experimente este treino',
    'minute read': 'minutos de leitura',
    'SAVING...': 'SALVANDO...',
    'MARK AS COMPLETE': 'MARCAR COMO CONCLUÍDA',
    'MARK AS INCOMPLETE': 'MARCAR COMO NÃO CONCLUÍDA',
    'YOUR PROGRESS': 'SEU PROGRESSO',
    'A look at the practice you have put in.':
        'Veja o progresso da sua prática.',
    'SESSIONS': 'SESSÕES',
    'BEST SCORE': 'MELHOR PONTUAÇÃO',
    'STREAK': 'SEQUÊNCIA',
    'Score progress': 'Progresso da pontuação',
    'Your 12 most recent drill results':
        'Seus 12 resultados de treino mais recentes',
    'Complete a drill to start your progress curve.':
        'Conclua um treino para iniciar sua curva de progresso.',
    'Complete another drill to see your curve.':
        'Conclua outro treino para ver sua curva.',
    'DRILL SCORE': 'PONTUAÇÃO DO TREINO',
    'Learning progress': 'Progresso de aprendizado',
    'YOUR PRACTICE STAYS YOURS': 'SUA PRÁTICA É SUA',
    'Plain-language policy': 'Política em linguagem simples',
    'SIM': 'SIM',
    'No active options': 'Nenhuma opção ativa',
    'Tap Target': 'Alvo de toque',
    'Reaction Test': 'Teste de reação',
    'Flick Shots': 'Disparos rápidos',
    'Tracking': 'Rastreamento',
    'Micro-Adjust': 'Microajuste',
    'Target Switching': 'Troca de alvos',
    'Peek Shot': 'Disparo surpresa',
    'Recoil Control': 'Controle de recuo',
    'Precision': 'Precisão',
    'Reaction': 'Reação',
    'Control': 'Controle',
    'Awareness': 'Percepção',
    'Practice': 'Prática',
    'Foundations': 'Fundamentos',
    'DRILL COMPLETE': 'TREINO CONCLUÍDO',
    'SCORE': 'PONTUAÇÃO',
    'NEW BEST': 'NOVO RECORDE',
    'BACK': 'VOLTAR',
    'RETRY': 'TENTAR NOVAMENTE',
    'Sensi Setup': 'Configuração de sensi',
    'Ball Setup': 'Configuração da bola',
    'Crosshair': 'Mira',
    'Controls': 'Controles',
    'Display': 'Tela',
    'Training Habits': 'Hábitos de treino',
    'Mobile Sensi': 'Sensi mobile',
    'Emu Sensi': 'Sensi de emulador',
    'HUD Phone': 'HUD do celular',
    'Device DPI': 'DPI do dispositivo',
    'AI Sensi and Aim': 'Sensi e mira com IA',
    'Aim Lock Practice Cue': 'Referência de mira fixa',
    'Gyroscope Aim': 'Mira giroscópica',
    'Custom HUD Layout': 'Layout HUD personalizado',
    'Fire Button Size': 'Tamanho do botão de tiro',
    '4-Finger Claw Layout': 'Layout de 4 dedos',
    'FPS': 'FPS',
    'RAM': 'RAM',
    'Ping Live': 'Ping ao vivo',
    'Show an in-app FPS reading (simulated)':
        'Mostrar leitura de FPS no app (simulado)',
    'Show an in-app RAM reading (simulated)':
        'Mostrar leitura de RAM no app (simulado)',
    'Show an in-app ping reading (simulated)':
        'Mostrar leitura de ping no app (simulada)',
    'High Frame Rate Mode': 'Modo de alta taxa de quadros',
    'Smooth Graphics': 'Gráficos suaves',
    'Screen Brightness Lock Reminder': 'Lembrete de brilho da tela',
    'Daily Warm-up Reminder': 'Lembrete de aquecimento diário',
    'Haptic Feedback': 'Resposta tátil',
    'Sound Effects': 'Efeitos sonoros',
    'Show Hit Markers in Drills': 'Mostrar marcadores de acerto',
    'Ball Overlay': 'Sobreposição da bola',
    'Crosshair Overlay': 'Sobreposição da mira',
    'Reset checklist': 'Redefinir lista',
    'These toggles track your own setup. Nothing in your phone or game is changed.':
        'Estas opções acompanham sua configuração. Nada no celular ou no jogo é alterado.',
    'Finding Your Sensitivity': 'Encontrando sua sensibilidade',
    'Crosshair Placement': 'Posicionamento da mira',
    'Thumb and Finger Mechanics': 'Mecânica dos dedos',
    'Flick vs Tracking': 'Flick ou rastreamento',
    'Recoil and Burst Control': 'Controle de recuo e rajadas',
    'Scope Handling': 'Uso da mira telescópica',
    'Warm-up Routine': 'Rotina de aquecimento',
    'Mindset and Consistency': 'Mentalidade e consistência',
    'min read': 'min de leitura',
    'lessons completed': 'lições concluídas',
    'of': 'de',
    'sec': 's',
    'ready': 'prontas',
    'Selected practice preferences activated in Training':
        'Preferências selecionadas ativadas no Treino',
    'Nothing on your phone or in a game is changed.':
        'Nada no celular ou no jogo é alterado.',
    'Simulated values are for demonstration only.':
        'Os valores simulados são apenas demonstrativos.',
    'Take a break during long sessions. Look away from the screen and relax your hands and eyes.':
        'Faça pausas em sessões longas. Desvie o olhar da tela e relaxe as mãos e os olhos.',
    'This clears your drill scores and history, lesson completion, and setup checklist.':
        'Isto apaga pontuações e histórico de treinos, lições concluídas e a lista de configuração.',
    'Your practice checklist, lesson progress, drill scores, and history are stored on this device. AppLovin may receive device and ad-interaction data to deliver and measure ads. Your ATT choice controls cross-app tracking on Apple devices. Sample device and performance values are made up. The app does not read or change game or phone settings.':
        'Sua lista de prática, progresso das lições, pontuações e histórico ficam salvos neste aparelho. O AppLovin pode receber dados do dispositivo e das interações com anúncios para exibi-los e medi-los. Sua escolha no ATT controla o rastreamento entre apps em dispositivos Apple. Os dados de dispositivo e desempenho são simulados. O app não lê nem altera configurações do jogo ou do celular.',
    'You can reset all saved data at any time from Settings. Resetting removes the app’s locally stored progress and preferences.':
        'Você pode apagar os dados salvos a qualquer momento em Configurações. Isso remove o progresso e as preferências armazenadas localmente.',
    'Ball color preference': 'Preferência de cor da bola',
    'Preferred ball size': 'Tamanho preferido da bola',
    'Hide / turn off': 'Ocultar / desativar',
    'Crosshair color': 'Cor da mira',
    'Settings · Pro Crosshair': 'Configurações · Mira Pro',
    'Touch sensitivity': 'Sensibilidade ao toque',
    'Emulator sensitivity note': 'Anotação de sensibilidade do emulador',
    'Preferred device DPI note': 'Anotação de DPI do aparelho',
    'Practice sensitivity note': 'Anotação de sensibilidade de treino',
    'Gyro practice sensitivity': 'Sensibilidade de giroscópio no treino',
    'Fire button size': 'Tamanho do botão de tiro',
    'Brightness reminder': 'Lembrete de brilho',
    'Warm-up length': 'Duração do aquecimento',
    'Phone HUD spacing': 'Espaçamento do HUD do celular',
    'Layout preset note': 'Anotação de layout',
    'Finger layout note': 'Anotação do layout de dedos',
    'Frame-rate target note': 'Anotação da meta de quadros',
    'Graphics preference': 'Preferência gráfica',
    'Saved preference only · no ball is drawn in Training':
        'Preferência salva; nenhuma bola aparece no Treino',
    'Compact': 'Compacto',
    'Reach': 'Alcance',
    'Thumbs': 'Polegares',
    'Claw': 'Garra',
    'Three fingers': 'Três dedos',
    'Four fingers': 'Quatro dedos',
    'Quality': 'Qualidade',
    'Classic': 'Clássica',
    'Dot': 'Ponto',
    'Circle': 'Círculo',
    'T-Shape': 'Formato T',
    'PRO': 'PRO',
    'Targets per minute': 'Alvos por minuto',
    'Tap single targets with calm, accurate placement.':
        'Toque em alvos individuais com calma e precisão.',
    'Wait for the cue, then respond without rushing.':
        'Espere o sinal e responda sem pressa.',
    'Move quickly from center to a far target.':
        'Mova-se rapidamente do centro até um alvo distante.',
    'Hold and follow a moving target with control.':
        'Segure e acompanhe um alvo móvel com controle.',
    'Make small corrections between close targets.':
        'Faça pequenas correções entre alvos próximos.',
    'Shift attention between numbered target positions.':
        'Alterne a atenção entre alvos numerados.',
    'React to a brief target appearance.': 'Reaja à breve aparição do alvo.',
    'Drag smoothly against the target drift.':
        'Arraste suavemente contra o movimento do alvo.',
    'Hold and drag to follow the target':
        'Toque e arraste para acompanhar o alvo',
    'Your chosen touch sensitivity': 'Sua sensibilidade de toque escolhida',
    'Your emulator preference': 'Sua preferência de emulador',
    'Your phone control layout': 'O layout de controles do celular',
    'Your personal DPI note': 'Sua anotação pessoal de DPI',
    'Your practice sensitivity preference':
        'Sua preferência de sensibilidade de treino',
    'Optional visual focus cue in drills':
        'Referência visual opcional nos treinos',
    'Your gyro preference': 'Sua preferência de giroscópio',
    'Your button arrangement': 'Sua disposição de botões',
    'Your preferred button size': 'Seu tamanho de botão preferido',
    'Your finger layout preference': 'Sua preferência de layout dos dedos',
    'Show a made-up in-app FPS reading': 'Mostrar FPS fictício no app',
    'Show a made-up in-app RAM reading': 'Mostrar RAM fictícia no app',
    'Show a made-up in-app ping reading': 'Mostrar ping fictício no app',
    'Reminder for your own setup': 'Lembrete para sua configuração',
    'Your graphics preference': 'Sua preferência gráfica',
    'A personal reminder': 'Um lembrete pessoal',
    'Your habit checklist': 'Sua lista de hábitos',
    'Feedback inside training drills': 'Retorno dentro dos treinos',
    'Visual drill feedback': 'Retorno visual do treino',
    'Saved overlay preference only':
        'Somente preferência salva da sobreposição',
    'Show or hide your training reticle': 'Mostrar ou ocultar a mira de treino',
    'Write down your current values, then test one small adjustment at a time.':
        'Anote seus valores atuais e teste um pequeno ajuste por vez.',
    'Keep a separate note for emulator play so the two setups do not get mixed.':
        'Mantenha uma anotação separada para o emulador.',
    'Place frequently used controls where your fingers can reach without stretching.':
        'Posicione controles frequentes ao alcance dos dedos.',
    'Treat DPI as a note for your setup. This checklist never changes device display settings.':
        'Use o DPI como anotação. Esta lista não altera a tela do aparelho.',
    'Adjust this saved practice note gradually. It does not control aim in a game.':
        'Ajuste esta anotação aos poucos. Ela não controla a mira no jogo.',
    'This preference is for a visual focus cue in this app only; it never locks aim or controls a game.':
        'Esta preferência é apenas uma referência visual no app; não fixa a mira nem controla um jogo.',
    'This is a generated demonstration value. The app does not read device frame rate.':
        'Este é um valor demonstrativo gerado. O app não lê a taxa de quadros.',
    'This is a generated demonstration value. The app does not inspect device memory.':
        'Este é um valor demonstrativo gerado. O app não verifica a memória do aparelho.',
    'This is a generated demonstration value. The app does not connect to a server or measure network latency.':
        'Este é um valor demonstrativo gerado. O app não se conecta a servidores nem mede a latência.',
    'Home': 'Início',
    'Training': 'Treino',
    'Device': 'Dispositivo',
    'Learn': 'Aprender',
    'Stats': 'Estatísticas',
    'TIME': 'TEMPO',
    'ROUND': 'RODADA',
    'HIT': 'ACERTOS',
    'Accuracy': 'Precisão',
    'Average reaction': 'Reação média',
    'Best reaction': 'Melhor reação',
    'Average time to hit': 'Tempo médio para acertar',
    'Turn practice profile off': 'Desativar perfil de prática',
    'Turn practice profile on': 'Ativar perfil de prática',
    'Model': 'Modelo',
    'Platform': 'Plataforma',
    'iOS version': 'Versão do iOS',
    'Display size': 'Tamanho da tela',
    'Display refresh': 'Atualização da tela',
    'Preset source': 'Origem do perfil',
    'iPhone · manual selection': 'iPhone · seleção manual',
    'Not read · sample panel': 'Não lido · painel de amostra',
    'Illustrative estimate': 'Estimativa ilustrativa',
    'Illustrative starting point only. Apple and games do not publish universal per-iPhone aim sensitivity values; tune these in your own game.':
        'Ponto de partida ilustrativo. Não há valores universais por iPhone; ajuste no seu próprio jogo.',
    'Sensitivity varies by game and player.':
        'A sensibilidade varia conforme o jogo e o jogador.',
    'Aura Aim keeps its promises simple.':
        'Aura Aim mantém suas promessas simples.',
    'Stats use practice history saved inside this app.':
        'As estatísticas usam o histórico salvo neste app.',
    'Your control layout': 'Seu layout de controles',
    'If you use gyro, try gentle tilts first and keep your wrists relaxed.':
        'Se usar giroscópio, comece com inclinações leves e relaxe os pulsos.',
    'Choose a size that is easy to tap without blocking your view.':
        'Escolha um tamanho fácil de tocar sem bloquear a visão.',
    'Build up gradually. Stop if a position causes discomfort or strain.':
        'Avance aos poucos. Pare se a posição causar desconforto.',
    'Check the game menu yourself and choose a mode that stays smooth on your device.':
        'Confira o menu do jogo e escolha um modo fluido no seu aparelho.',
    'A consistent picture can make target movement easier to read.':
        'Uma imagem consistente facilita acompanhar os alvos.',
    'Set a comfortable brightness before a session and avoid glare.':
        'Ajuste um brilho confortável e evite reflexos.',
    'Start with a few minutes of easy, controlled practice before raising difficulty.':
        'Comece com alguns minutos de prática fácil antes de aumentar a dificuldade.',
    'When enabled, supported drills use a short vibration on a hit.':
        'Quando ativado, alguns treinos vibram brevemente ao acertar.',
    'When enabled, supported drills play a light system click on a hit.':
        'Quando ativado, alguns treinos reproduzem um clique ao acertar.',
    'Hit markers can help you notice successful timing during practice.':
        'Marcadores ajudam a notar o tempo dos acertos durante a prática.',
    'Choose whether your ball overlay preference is on or hidden. This app saves the setting but never draws a ball in Training.':
        'Escolha sua preferência de sobreposição. O app salva a opção, mas nunca desenha uma bola no Treino.',
    'Switch this on to use your chosen crosshair color and Pro Crosshair style in drills.':
        'Ative para usar a cor e o estilo de mira escolhidos nos treinos.',
    'TAP!': 'TOQUE!',
    'WAIT': 'AGUARDE',
    'Activate at least one feature': 'Ative pelo menos um recurso',
    'Aim Trainer': 'Treino de mira',
    'Speed': 'Velocidade',
    'Moving': 'Em movimento',
    'Daily': 'Diário',
    'One target at a time. Steady pace.':
        'Um alvo por vez, em ritmo constante.',
    'Targets vanish fast. Stay sharp.':
        'Os alvos somem rápido. Mantenha o foco.',
    'Small targets. Accuracy matters.': 'Alvos pequenos. A precisão importa.',
    'Two bouncing targets at once.': 'Dois alvos em movimento ao mesmo tempo.',
    'Same target layout for everyone today.':
        'O mesmo arranjo de alvos para todos hoje.',
    'Direct tap': 'Toque direto',
    'Drag + Fire': 'Arraste e dispare',
    'Drag speed': 'Velocidade do arraste',
    'from your General sensitivity slider':
        'conforme o controle de sensibilidade Geral',
    'Stop': 'Parar',
    'Play again': 'Jogar novamente',
    'Lifetime': 'Total acumulado',
    'Sessions': 'Sessões',
    'Total hits': 'Acertos totais',
    'Best streak': 'Melhor sequência',
    'Personal bests': 'Recordes pessoais',
    'Recent scores': 'Pontuações recentes',
    'Achievements': 'Conquistas',
    'Play two sessions to see your trend.':
        'Jogue duas sessões para ver sua tendência.',
    'First Blood': 'Primeiro acerto',
    'Finish your first session': 'Conclua sua primeira sessão',
    'Sharpshooter': 'Atirador preciso',
    '90% accuracy with 20+ shots': '90% de precisão com 20 ou mais disparos',
    'Quick Draw': 'Saque rápido',
    'Average under 600 ms (10+ hits)':
        'Média abaixo de 600 ms (10 ou mais acertos)',
    'On Fire': 'Em chamas',
    'Hit a streak of 15': 'Alcance uma sequência de 15 acertos',
    'Centurion': 'Centurião',
    '100 total hits': '100 acertos no total',
    'Profile Hopper': 'Explorador de perfis',
    'Play with 3 different profiles': 'Jogue com 3 perfis diferentes',
    'FPS · SIM': 'FPS · SIM',
    'RAM · SIM': 'RAM · SIM',
    'PING · SIM': 'PING · SIM',
    'Press Start': 'Toque em Iniciar',
    'FIRE': 'DISPARAR',
    'NEW PERSONAL BEST': 'NOVO RECORDE PESSOAL',
    'pts': 'pts',
    'Avg reaction': 'Reação média',
    'Best': 'Melhor',
    'Hits': 'Acertos',
    'Misses': 'Erros',
    'Escaped': 'Escaparam',
    'Reaction time per hit': 'Tempo de reação por acerto',
    'Cross': 'Cruz',
    'Plus': 'Mais',
    'Profiles': 'Perfis',
    'saved': 'salvos',
    'Swipe a card to switch. Crosshair and sensitivity change instantly.':
        'Deslize para trocar de perfil. A mira e a sensibilidade mudam na hora.',
    'No profiles yet. Tap "Save current setup" to create one.':
        'Ainda não há perfis. Toque em "Salvar configuração atual" para criar um.',
    'Unsaved changes on': 'Alterações não salvas em',
    'Revert': 'Reverter',
    'Update profile': 'Atualizar perfil',
    'Tune active profile': 'Ajustar perfil ativo',
    'Manage': 'Gerenciar',
    'Save current setup': 'Salvar configuração atual',
    'Import from code': 'Importar de código',
    'Profile Lab': 'Laboratório de perfis',
    'Crosshair style': 'Estilo da mira',
    'Sensitivity': 'Sensibilidade',
    'Play the Aim Trainer with different profiles to see which setup scores best.':
        'Jogue no Treino de mira com perfis diferentes para comparar as pontuações.',
    'ACTIVE': 'ATIVO',
    'sessions': 'sessões',
    'No trainer score yet': 'Sem pontuação no treinador',
    'Rename': 'Renomear',
    'Duplicate': 'Duplicar',
    'Share code / QR': 'Compartilhar código / QR',
    'Drill library': 'Biblioteca de treinos',
    'Monitor': 'Monitor',
    'My setup': 'Minha configuração',
    'Imported': 'Importado',
    'Rename profile': 'Renomear perfil',
    'This cannot be undone.': 'Esta ação não pode ser desfeita.',
    'Share': 'Compartilhar',
    'Code copied': 'Código copiado',
    'Copy code': 'Copiar código',
    'Close': 'Fechar',
    'Import profile': 'Importar perfil',
    'Paste an FFP1: code': 'Cole um código FFP1:',
    'Paste': 'Colar',
    'Import': 'Importar',
    'Profile name': 'Nome do perfil',
    'Size': 'Tamanho',
    'Thickness': 'Espessura',
    'Gap': 'Intervalo',
    'Opacity': 'Opacidade',
    'Save': 'Salvar',
    'That is not a valid Aura profile code.':
        'Este código de perfil Aura não é válido.',
    'Haptic tap on hits and misses while the practice profile is ON':
        'Vibra ao acertar e errar quando o perfil de prática está ativado',
    'System click on hits and misses while the practice profile is ON':
        'Som de clique do sistema ao acertar e errar com o perfil ativo',
    'When enabled, the active practice profile gives a medium haptic on a hit and a light haptic on a miss.':
        'Com o perfil ativo, vibra com intensidade média ao acertar e leve ao errar.',
    'When enabled, the active practice profile plays the device system click after hits and misses.':
        'Com o perfil ativo, reproduz o clique do sistema após acertos e erros.',
    'Hits use a medium vibration; misses use a lighter vibration while the practice profile is on.':
        'Acertos usam vibração média; erros usam vibração leve com o perfil de prática ativo.',
    'A short system click plays after hits and misses while the practice profile is on.':
        'Um clique curto do sistema toca após acertos e erros com o perfil ativo.',
  },
  'es': {
    'Your checklist, lesson progress, drill scores, and history are stored on this device. Sample device and performance values are made up. The app does not read or change game or phone settings.':
        'Tu lista, progreso de lecciones, puntuaciones e historial se guardan en este dispositivo. Los datos del dispositivo y rendimiento son simulados. La app no lee ni cambia los ajustes del juego o del móvil.',
    'Practice with purpose': 'Entrena con intención',
    'Privacy and control': 'Privacidad y control',
    'Your progress stays on this device. Nothing in your game or phone is changed.':
        'Tu progreso se guarda en este dispositivo. No se cambia nada en el juego ni en el móvil.',
    'Rewarded ad feature': 'Función con anuncio recompensado',
    'Build steadier aim with short drills, progress tracking, and practical lessons.':
        'Mejora la puntería con ejercicios breves, seguimiento del progreso y lecciones prácticas.',
    'Your setup stays yours': 'Tu configuración sigue siendo tuya',
    'Checklist choices stay in this app. Nothing in your game or phone is changed.':
        'Las opciones se guardan en esta app. No se cambia nada en el juego ni en el móvil.',
    'Ads and your choice': 'Anuncios y tu elección',
    'Dark Aura uses AppLovin to show ads. If you allow tracking, its ad partners may use identifiers to measure ads and make them more relevant. Ads may still appear if you decline.':
        'Dark Aura usa AppLovin para mostrar anuncios. Si permites el seguimiento, sus socios publicitarios pueden usar identificadores para medir los anuncios y hacerlos más relevantes. Si lo rechazas, pueden seguir apareciendo anuncios.',
    'On iPhone and iPad, you can choose whether to allow ad tracking.':
        'En iPhone y iPad, puedes elegir si permites el seguimiento publicitario.',
    'Continue': 'Continuar',
    'Continue without tracking': 'Continuar sin seguimiento',
    'Next': 'Siguiente',
    'Skip': 'Omitir',
    'Enable with a rewarded ad?': '¿Activar con un anuncio recompensado?',
    'Watch a short ad to enable this training option. It turns on only after the reward is confirmed.':
        'Mira un anuncio breve para activar esta opción de entrenamiento. Se activará cuando se confirme la recompensa.',
    'Not now': 'Ahora no',
    'Watch ad': 'Ver anuncio',
    'Feature enabled': 'Función activada',
    'Ad is not ready. Try again soon.':
        'El anuncio no está listo. Inténtalo pronto.',
    'AppLovin may receive device and ad-interaction data to deliver and measure ads. Your ATT choice controls cross-app tracking on Apple devices. For details about AppLovin’s collection and use of information, visit:':
        'AppLovin puede recibir datos del dispositivo y de interacciones con anuncios para mostrarlos y medirlos. Tu elección de ATT controla el seguimiento entre apps en dispositivos Apple. Para conocer cómo AppLovin recopila y usa información, visita:',
    'AppLovin Privacy Policy': 'Política de privacidad de AppLovin',
    'Settings': 'Ajustes',
    'Privacy Policy': 'Política de privacidad',
    'How your local app data is handled':
        'Cómo se gestionan los datos locales de la app',
    'Share App': 'Compartir app',
    'Tell someone about Aura Aim': 'Cuéntale a alguien sobre Aura Aim',
    'Rate App': 'Valorar app',
    'Open the app store page': 'Abrir la página de la tienda',
    'Reset all progress': 'Borrar todo el progreso',
    'Clear scores, lessons, streaks, and toggles':
        'Borrar puntuaciones, lecciones, rachas y opciones',
    'About': 'Acerca de',
    'Version and app details': 'Versión y detalles de la app',
    'Language': 'Idioma',
    'Choose the language used throughout the app':
        'Elige el idioma de toda la app',
    'Reset all progress?': '¿Borrar todo el progreso?',
    'Cancel': 'Cancelar',
    'Reset everything': 'Borrar todo',
    'All progress cleared': 'Se borró todo el progreso',
    'Your Practice Snapshot': 'Resumen de práctica',
    'DAILY STREAK': 'RACHA DIARIA',
    'DRILLS DONE': 'EJERCICIOS HECHOS',
    'LESSONS': 'LECCIONES',
    'days': 'días',
    'Practice profile enabled': 'Perfil de práctica activado',
    'Tap to enable practice profile': 'Toca para activar el perfil de práctica',
    'SENSI RESULT': 'RESULTADO DE SENSI',
    'Scale 0 to 200': 'Escala de 0 a 200',
    'GENERATED': 'GENERADO',
    'SAMPLE PREVIEW': 'VISTA DE MUESTRA',
    'Sensitivity Generator (simulated)': 'Generador de sensibilidad (simulado)',
    'Device type': 'Tipo de dispositivo',
    'Play style': 'Estilo de juego',
    'Low-end': 'Básico',
    'Mid-range': 'Medio',
    'High-end': 'Avanzado',
    'Tablet': 'Tableta',
    'Defensive': 'Defensivo',
    'Balanced': 'Equilibrado',
    'Aggressive': 'Agresivo',
    'GENERATE': 'GENERAR',
    'GENERATING...': 'GENERANDO...',
    'Copy': 'Copiar',
    'Copied simulated values': 'Valores simulados copiados',
    'General': 'General',
    'Red Dot': 'Punto rojo',
    'Device Info (sample data)':
        'Información del dispositivo (datos de muestra)',
    'Live Performance (simulated)': 'Rendimiento en vivo (simulado)',
    'iPhone model · choose manually': 'Modelo de iPhone · selección manual',
    'Sample baseline': 'Base de muestra',
    'TRAIN WITH INTENTION': 'ENTRENA CON INTENCIÓN',
    'Short practice rounds for timing, control, and precision.':
        'Rondas breves para practicar ritmo, control y precisión.',
    'Round length': 'Duración de ronda',
    'Easy': 'Fácil',
    'Medium': 'Medio',
    'Hard': 'Difícil',
    'Start': 'Empezar',
    'Trains': 'Entrena',
    'BEST': 'MEJOR',
    'Learning Progress': 'Progreso de aprendizaje',
    'lessons complete': 'lecciones completadas',
    'Complete': 'Completada',
    'Key takeaways': 'Ideas clave',
    'Try this drill': 'Probar este ejercicio',
    'minute read': 'minutos de lectura',
    'SAVING...': 'GUARDANDO...',
    'MARK AS COMPLETE': 'MARCAR COMO COMPLETADA',
    'MARK AS INCOMPLETE': 'MARCAR COMO INCOMPLETA',
    'YOUR PROGRESS': 'TU PROGRESO',
    'A look at the practice you have put in.': 'Un vistazo a tu práctica.',
    'SESSIONS': 'SESIONES',
    'BEST SCORE': 'MEJOR PUNTUACIÓN',
    'STREAK': 'RACHA',
    'Score progress': 'Progreso de puntuación',
    'Your 12 most recent drill results':
        'Tus 12 resultados de ejercicio más recientes',
    'Complete a drill to start your progress curve.':
        'Completa un ejercicio para iniciar tu curva de progreso.',
    'Complete another drill to see your curve.':
        'Completa otro ejercicio para ver tu curva.',
    'DRILL SCORE': 'PUNTUACIÓN DEL EJERCICIO',
    'Learning progress': 'Progreso de aprendizaje',
    'YOUR PRACTICE STAYS YOURS': 'TU PRÁCTICA SIGUE SIENDO TUYA',
    'Plain-language policy': 'Política en lenguaje sencillo',
    'SIM': 'SIM',
    'No active options': 'No hay opciones activas',
    'Tap Target': 'Toque al objetivo',
    'Reaction Test': 'Prueba de reacción',
    'Flick Shots': 'Disparos rápidos',
    'Tracking': 'Seguimiento',
    'Micro-Adjust': 'Microajuste',
    'Target Switching': 'Cambio de objetivos',
    'Peek Shot': 'Disparo sorpresa',
    'Recoil Control': 'Control del retroceso',
    'Precision': 'Precisión',
    'Reaction': 'Reacción',
    'Control': 'Control',
    'Awareness': 'Percepción',
    'Practice': 'Práctica',
    'Foundations': 'Fundamentos',
    'DRILL COMPLETE': 'EJERCICIO COMPLETADO',
    'SCORE': 'PUNTUACIÓN',
    'NEW BEST': 'NUEVO RÉCORD',
    'BACK': 'VOLVER',
    'RETRY': 'REPETIR',
    'Sensi Setup': 'Ajuste de sensi',
    'Ball Setup': 'Ajuste de bola',
    'Crosshair': 'Mira',
    'Controls': 'Controles',
    'Display': 'Pantalla',
    'Training Habits': 'Hábitos de práctica',
    'Mobile Sensi': 'Sensi móvil',
    'Emu Sensi': 'Sensi de emulador',
    'HUD Phone': 'HUD del móvil',
    'Device DPI': 'DPI del dispositivo',
    'AI Sensi and Aim': 'Sensi y mira con IA',
    'Aim Lock Practice Cue': 'Guía de fijación de mira',
    'Gyroscope Aim': 'Mira con giroscopio',
    'Custom HUD Layout': 'Diseño HUD personalizado',
    'Fire Button Size': 'Tamaño del botón de disparo',
    '4-Finger Claw Layout': 'Diseño de cuatro dedos',
    'FPS': 'FPS',
    'RAM': 'RAM',
    'Ping Live': 'Ping en vivo',
    'Show an in-app FPS reading (simulated)':
        'Mostrar lectura de FPS en la app (simulado)',
    'Show an in-app RAM reading (simulated)':
        'Mostrar lectura de RAM en la app (simulada)',
    'Show an in-app ping reading (simulated)':
        'Mostrar lectura de ping en la app (simulada)',
    'High Frame Rate Mode': 'Modo de alta frecuencia',
    'Smooth Graphics': 'Gráficos fluidos',
    'Screen Brightness Lock Reminder': 'Recordatorio de brillo de pantalla',
    'Daily Warm-up Reminder': 'Recordatorio de calentamiento',
    'Haptic Feedback': 'Respuesta háptica',
    'Sound Effects': 'Efectos de sonido',
    'Show Hit Markers in Drills': 'Mostrar marcas de acierto',
    'Ball Overlay': 'Superposición de bola',
    'Crosshair Overlay': 'Superposición de mira',
    'Reset checklist': 'Restablecer lista',
    'These toggles track your own setup. Nothing in your phone or game is changed.':
        'Estas opciones registran tu configuración. No cambian nada en tu móvil ni en el juego.',
    'Finding Your Sensitivity': 'Cómo encontrar tu sensibilidad',
    'Crosshair Placement': 'Colocación de la mira',
    'Thumb and Finger Mechanics': 'Mecánica de dedos',
    'Flick vs Tracking': 'Flick y seguimiento',
    'Recoil and Burst Control': 'Control del retroceso y ráfagas',
    'Scope Handling': 'Uso de la mira telescópica',
    'Warm-up Routine': 'Rutina de calentamiento',
    'Mindset and Consistency': 'Mentalidad y constancia',
    'min read': 'min de lectura',
    'lessons completed': 'lecciones completadas',
    'of': 'de',
    'sec': 's',
    'ready': 'listas',
    'Selected practice preferences activated in Training':
        'Preferencias seleccionadas activadas en Entrenamiento',
    'Nothing on your phone or in a game is changed.':
        'No se cambia nada en tu móvil ni en el juego.',
    'Simulated values are for demonstration only.':
        'Los valores simulados son solo demostrativos.',
    'Take a break during long sessions. Look away from the screen and relax your hands and eyes.':
        'Descansa durante las sesiones largas. Aparta la vista y relaja las manos y los ojos.',
    'This clears your drill scores and history, lesson completion, and setup checklist.':
        'Esto borra puntuaciones e historial, lecciones completadas y la lista de configuración.',
    'Your practice checklist, lesson progress, drill scores, and history are stored on this device. AppLovin may receive device and ad-interaction data to deliver and measure ads. Your ATT choice controls cross-app tracking on Apple devices. Sample device and performance values are made up. The app does not read or change game or phone settings.':
        'Tu lista de práctica, progreso de lecciones, puntuaciones e historial se guardan en este dispositivo. AppLovin puede recibir datos del dispositivo e interacciones con anuncios para mostrarlos y medirlos. Tu elección de ATT controla el seguimiento entre apps en dispositivos Apple. Los datos de dispositivo y rendimiento son simulados. La app no lee ni cambia los ajustes del juego o del móvil.',
    'You can reset all saved data at any time from Settings. Resetting removes the app’s locally stored progress and preferences.':
        'Puedes borrar los datos guardados desde Ajustes cuando quieras. Se eliminarán el progreso y las preferencias locales.',
    'Ball color preference': 'Preferencia de color de bola',
    'Preferred ball size': 'Tamaño de bola preferido',
    'Hide / turn off': 'Ocultar / desactivar',
    'Crosshair color': 'Color de mira',
    'Settings · Pro Crosshair': 'Ajustes · Mira Pro',
    'Touch sensitivity': 'Sensibilidad táctil',
    'Emulator sensitivity note': 'Nota de sensibilidad del emulador',
    'Preferred device DPI note': 'Nota de DPI del dispositivo',
    'Practice sensitivity note': 'Nota de sensibilidad de práctica',
    'Gyro practice sensitivity': 'Sensibilidad de giroscopio en práctica',
    'Fire button size': 'Tamaño del botón de disparo',
    'Brightness reminder': 'Recordatorio de brillo',
    'Warm-up length': 'Duración del calentamiento',
    'Phone HUD spacing': 'Espaciado HUD del móvil',
    'Layout preset note': 'Nota de diseño',
    'Finger layout note': 'Nota de diseño de dedos',
    'Frame-rate target note': 'Nota de objetivo de FPS',
    'Graphics preference': 'Preferencia gráfica',
    'Saved preference only · no ball is drawn in Training':
        'Preferencia guardada; no se muestra ninguna bola en Entrenamiento',
    'Compact': 'Compacto',
    'Reach': 'Alcance',
    'Thumbs': 'Pulgares',
    'Claw': 'Garra',
    'Three fingers': 'Tres dedos',
    'Four fingers': 'Cuatro dedos',
    'Quality': 'Calidad',
    'Classic': 'Clásica',
    'Dot': 'Punto',
    'Circle': 'Círculo',
    'T-Shape': 'Forma de T',
    'PRO': 'PRO',
    'Targets per minute': 'Objetivos por minuto',
    'Tap single targets with calm, accurate placement.':
        'Toca objetivos individuales con calma y precisión.',
    'Wait for the cue, then respond without rushing.':
        'Espera la señal y responde sin prisa.',
    'Move quickly from center to a far target.':
        'Muévete rápido del centro a un objetivo lejano.',
    'Hold and follow a moving target with control.':
        'Mantén y sigue un objetivo móvil con control.',
    'Make small corrections between close targets.':
        'Haz pequeñas correcciones entre objetivos cercanos.',
    'Shift attention between numbered target positions.':
        'Cambia la atención entre objetivos numerados.',
    'React to a brief target appearance.':
        'Reacciona a la breve aparición del objetivo.',
    'Drag smoothly against the target drift.':
        'Arrastra suavemente contra el movimiento del objetivo.',
    'Hold and drag to follow the target':
        'Mantén y arrastra para seguir el objetivo',
    'Your chosen touch sensitivity': 'Tu sensibilidad táctil elegida',
    'Your emulator preference': 'Tu preferencia de emulador',
    'Your phone control layout': 'Tu diseño de controles del móvil',
    'Your personal DPI note': 'Tu nota personal de DPI',
    'Your practice sensitivity preference':
        'Tu preferencia de sensibilidad de práctica',
    'Optional visual focus cue in drills': 'Guía visual opcional en ejercicios',
    'Your gyro preference': 'Tu preferencia de giroscopio',
    'Your button arrangement': 'Tu disposición de botones',
    'Your preferred button size': 'Tu tamaño de botón preferido',
    'Your finger layout preference': 'Tu preferencia de diseño de dedos',
    'Show a made-up in-app FPS reading': 'Mostrar FPS ficticios en la app',
    'Show a made-up in-app RAM reading': 'Mostrar RAM ficticia en la app',
    'Show a made-up in-app ping reading': 'Mostrar ping ficticio en la app',
    'Reminder for your own setup': 'Recordatorio para tu configuración',
    'Your graphics preference': 'Tu preferencia gráfica',
    'A personal reminder': 'Un recordatorio personal',
    'Your habit checklist': 'Tu lista de hábitos',
    'Feedback inside training drills': 'Respuesta dentro de los ejercicios',
    'Visual drill feedback': 'Respuesta visual del ejercicio',
    'Saved overlay preference only':
        'Solo preferencia guardada de superposición',
    'Show or hide your training reticle':
        'Mostrar u ocultar la mira de práctica',
    'Write down your current values, then test one small adjustment at a time.':
        'Anota tus valores actuales y prueba un pequeño ajuste cada vez.',
    'Keep a separate note for emulator play so the two setups do not get mixed.':
        'Guarda una nota aparte para el emulador.',
    'Place frequently used controls where your fingers can reach without stretching.':
        'Coloca los controles habituales al alcance de los dedos.',
    'Treat DPI as a note for your setup. This checklist never changes device display settings.':
        'Usa el DPI como una nota. Esta lista nunca modifica la pantalla.',
    'Adjust this saved practice note gradually. It does not control aim in a game.':
        'Ajusta esta nota poco a poco. No controla la mira en el juego.',
    'This preference is for a visual focus cue in this app only; it never locks aim or controls a game.':
        'Esta opción solo muestra una guía visual en la app; no fija la mira ni controla el juego.',
    'This is a generated demonstration value. The app does not read device frame rate.':
        'Este valor demostrativo es generado. La app no lee los FPS del dispositivo.',
    'This is a generated demonstration value. The app does not inspect device memory.':
        'Este valor demostrativo es generado. La app no consulta la memoria del dispositivo.',
    'This is a generated demonstration value. The app does not connect to a server or measure network latency.':
        'Este valor demostrativo es generado. La app no se conecta a servidores ni mide la latencia.',
    'Home': 'Inicio',
    'Training': 'Entrenamiento',
    'Device': 'Dispositivo',
    'Learn': 'Aprender',
    'Stats': 'Estadísticas',
    'TIME': 'TIEMPO',
    'ROUND': 'RONDA',
    'HIT': 'ACIERTOS',
    'Accuracy': 'Precisión',
    'Average reaction': 'Reacción media',
    'Best reaction': 'Mejor reacción',
    'Average time to hit': 'Tiempo medio para acertar',
    'Turn practice profile off': 'Desactivar perfil de práctica',
    'Turn practice profile on': 'Activar perfil de práctica',
    'Activate at least one feature': 'Activa al menos una función',
    'Aim Trainer': 'Entrenamiento de puntería',
    'Speed': 'Velocidad',
    'Moving': 'En movimiento',
    'Daily': 'Diario',
    'One target at a time. Steady pace.':
        'Un objetivo a la vez, a ritmo constante.',
    'Targets vanish fast. Stay sharp.':
        'Los objetivos desaparecen rápido. Mantén la atención.',
    'Small targets. Accuracy matters.':
        'Objetivos pequeños. La precisión importa.',
    'Two bouncing targets at once.': 'Dos objetivos en movimiento a la vez.',
    'Same target layout for everyone today.':
        'El mismo diseño de objetivos para todos hoy.',
    'Direct tap': 'Toque directo',
    'Drag + Fire': 'Arrastrar y disparar',
    'Drag speed': 'Velocidad de arrastre',
    'from your General sensitivity slider':
        'según el control de sensibilidad General',
    'Stop': 'Detener',
    'Play again': 'Jugar otra vez',
    'Lifetime': 'Acumulado',
    'Sessions': 'Sesiones',
    'Total hits': 'Aciertos totales',
    'Best streak': 'Mejor racha',
    'Personal bests': 'Mejores marcas',
    'Recent scores': 'Puntuaciones recientes',
    'Achievements': 'Logros',
    'Play two sessions to see your trend.':
        'Juega dos sesiones para ver la tendencia.',
    'First Blood': 'Primer acierto',
    'Finish your first session': 'Termina tu primera sesión',
    'Sharpshooter': 'Tirador preciso',
    '90% accuracy with 20+ shots': '90 % de precisión con 20 disparos o más',
    'Quick Draw': 'Desenfunde rápido',
    'Average under 600 ms (10+ hits)':
        'Media inferior a 600 ms (10 aciertos o más)',
    'On Fire': 'En racha',
    'Hit a streak of 15': 'Consigue una racha de 15 aciertos',
    'Centurion': 'Centurión',
    '100 total hits': '100 aciertos en total',
    'Profile Hopper': 'Cambia perfiles',
    'Play with 3 different profiles': 'Juega con 3 perfiles distintos',
    'FPS · SIM': 'FPS · SIM',
    'RAM · SIM': 'RAM · SIM',
    'PING · SIM': 'PING · SIM',
    'Press Start': 'Pulsa Iniciar',
    'FIRE': 'DISPARAR',
    'NEW PERSONAL BEST': 'NUEVA MEJOR MARCA',
    'pts': 'pts',
    'Avg reaction': 'Reacción media',
    'Best': 'Mejor',
    'Hits': 'Aciertos',
    'Misses': 'Fallos',
    'Escaped': 'Escapados',
    'Reaction time per hit': 'Tiempo de reacción por acierto',
    'Cross': 'Cruz',
    'Plus': 'Más',
    'Profiles': 'Perfiles',
    'saved': 'guardados',
    'Swipe a card to switch. Crosshair and sensitivity change instantly.':
        'Desliza para cambiar de perfil. La mira y la sensibilidad se actualizan al instante.',
    'No profiles yet. Tap "Save current setup" to create one.':
        'Aún no hay perfiles. Pulsa "Guardar configuración actual" para crear uno.',
    'Unsaved changes on': 'Cambios sin guardar en',
    'Revert': 'Revertir',
    'Update profile': 'Actualizar perfil',
    'Tune active profile': 'Ajustar perfil activo',
    'Manage': 'Administrar',
    'Save current setup': 'Guardar configuración actual',
    'Import from code': 'Importar desde código',
    'Profile Lab': 'Laboratorio de perfiles',
    'Crosshair style': 'Estilo de mira',
    'Sensitivity': 'Sensibilidad',
    'Play the Aim Trainer with different profiles to see which setup scores best.':
        'Prueba distintos perfiles en el entrenador para comparar sus puntuaciones.',
    'ACTIVE': 'ACTIVO',
    'sessions': 'sesiones',
    'No trainer score yet': 'Aún no hay puntuación',
    'Rename': 'Renombrar',
    'Duplicate': 'Duplicar',
    'Share code / QR': 'Compartir código / QR',
    'Drill library': 'Biblioteca de ejercicios',
    'Monitor': 'Monitor',
    'My setup': 'Mi configuración',
    'Imported': 'Importado',
    'Rename profile': 'Renombrar perfil',
    'This cannot be undone.': 'Esta acción no se puede deshacer.',
    'Share': 'Compartir',
    'Code copied': 'Código copiado',
    'Copy code': 'Copiar código',
    'Close': 'Cerrar',
    'Import profile': 'Importar perfil',
    'Paste an FFP1: code': 'Pega un código FFP1:',
    'Paste': 'Pegar',
    'Import': 'Importar',
    'Profile name': 'Nombre del perfil',
    'Size': 'Tamaño',
    'Thickness': 'Grosor',
    'Gap': 'Separación',
    'Opacity': 'Opacidad',
    'Save': 'Guardar',
    'That is not a valid Aura profile code.':
        'Este código de perfil Aura no es válido.',
    'Haptic tap on hits and misses while the practice profile is ON':
        'Vibra al acertar y fallar cuando el perfil de práctica está activado',
    'System click on hits and misses while the practice profile is ON':
        'Sonido de clic del sistema al acertar y fallar con el perfil activo',
    'When enabled, the active practice profile gives a medium haptic on a hit and a light haptic on a miss.':
        'Con el perfil activo, vibra con intensidad media al acertar y suave al fallar.',
    'When enabled, the active practice profile plays the device system click after hits and misses.':
        'Con el perfil activo, reproduce el clic del sistema tras aciertos y fallos.',
    'Hits use a medium vibration; misses use a lighter vibration while the practice profile is on.':
        'Los aciertos usan una vibración media y los fallos una más suave con el perfil activo.',
    'A short system click plays after hits and misses while the practice profile is on.':
        'Suena un clic breve del sistema tras aciertos y fallos con el perfil activo.',
    'Model': 'Modelo',
    'Platform': 'Plataforma',
    'iOS version': 'Versión de iOS',
    'Display size': 'Tamaño de pantalla',
    'Display refresh': 'Frecuencia de pantalla',
    'Preset source': 'Origen del perfil',
    'iPhone · manual selection': 'iPhone · selección manual',
    'Not read · sample panel': 'No leído · panel de muestra',
    'Illustrative estimate': 'Estimación ilustrativa',
    'Illustrative starting point only. Apple and games do not publish universal per-iPhone aim sensitivity values; tune these in your own game.':
        'Punto de partida ilustrativo. No hay valores universales por iPhone; ajústalos en tu propio juego.',
    'Sensitivity varies by game and player.':
        'La sensibilidad varía según el juego y cada jugador.',
    'Aura Aim keeps its promises simple.':
        'Aura Aim mantiene sus promesas sencillas.',
    'Stats use practice history saved inside this app.':
        'Las estadísticas usan el historial guardado en esta app.',
    'Your control layout': 'Tu diseño de controles',
    'If you use gyro, try gentle tilts first and keep your wrists relaxed.':
        'Si usas giroscopio, empieza con inclinaciones suaves y relaja las muñecas.',
    'Choose a size that is easy to tap without blocking your view.':
        'Elige un tamaño fácil de tocar que no tape la vista.',
    'Build up gradually. Stop if a position causes discomfort or strain.':
        'Avanza poco a poco. Para si una posición causa molestias.',
    'Check the game menu yourself and choose a mode that stays smooth on your device.':
        'Revisa el menú del juego y elige un modo fluido para tu dispositivo.',
    'A consistent picture can make target movement easier to read.':
        'Una imagen estable facilita leer el movimiento de los objetivos.',
    'Set a comfortable brightness before a session and avoid glare.':
        'Ajusta un brillo cómodo y evita reflejos.',
    'Start with a few minutes of easy, controlled practice before raising difficulty.':
        'Empieza con unos minutos de práctica fácil antes de subir la dificultad.',
    'When enabled, supported drills use a short vibration on a hit.':
        'Al activarlo, algunos ejercicios vibran brevemente al acertar.',
    'When enabled, supported drills play a light system click on a hit.':
        'Al activarlo, algunos ejercicios reproducen un clic al acertar.',
    'Hit markers can help you notice successful timing during practice.':
        'Las marcas ayudan a notar el ritmo de los aciertos.',
    'Choose whether your ball overlay preference is on or hidden. This app saves the setting but never draws a ball in Training.':
        'Elige la preferencia de superposición. La app la guarda, pero nunca dibuja una bola en Entrenamiento.',
    'Switch this on to use your chosen crosshair color and Pro Crosshair style in drills.':
        'Actívalo para usar el color y estilo de mira elegidos en los ejercicios.',
    'TAP!': '¡TOCA!',
    'WAIT': 'ESPERA',
  },
  'ar': {
    'Your checklist, lesson progress, drill scores, and history are stored on this device. Sample device and performance values are made up. The app does not read or change game or phone settings.':
        'تُحفظ قائمة التدريب وتقدم الدروس والنتائج والسجل على هذا الجهاز. بيانات الجهاز والأداء تجريبية. لا يقرأ التطبيق إعدادات الهاتف أو اللعبة ولا يغيّرها.',
    'Practice with purpose': 'تدرّب بهدف',
    'Privacy and control': 'الخصوصية والتحكم',
    'Your progress stays on this device. Nothing in your game or phone is changed.':
        'يبقى تقدمك على هذا الجهاز ولا تتغير إعدادات الهاتف أو اللعبة.',
    'Rewarded ad feature': 'ميزة بإعلان ومكافأة',
    'Build steadier aim with short drills, progress tracking, and practical lessons.':
        'حسّن ثبات التصويب عبر تدريبات قصيرة ومتابعة التقدم ودروس عملية.',
    'Your setup stays yours': 'إعداداتك تبقى لك',
    'Checklist choices stay in this app. Nothing in your game or phone is changed.':
        'تبقى خيارات القائمة داخل التطبيق ولا تغيّر إعدادات الهاتف أو اللعبة.',
    'Ads and your choice': 'الإعلانات وخيارك',
    'Dark Aura uses AppLovin to show ads. If you allow tracking, its ad partners may use identifiers to measure ads and make them more relevant. Ads may still appear if you decline.':
        'يستخدم Dark Aura خدمة AppLovin لعرض الإعلانات. إذا سمحت بالتتبع، فقد يستخدم شركاء الإعلانات المعرّفات لقياس الإعلانات وجعلها أكثر ملاءمة. قد تستمر الإعلانات في الظهور إذا رفضت.',
    'On iPhone and iPad, you can choose whether to allow ad tracking.':
        'يمكنك اختيار السماح بتتبع الإعلانات على iPhone وiPad.',
    'Continue': 'متابعة',
    'Continue without tracking': 'المتابعة دون تتبع',
    'Next': 'التالي',
    'Skip': 'تخطّي',
    'Enable with a rewarded ad?': 'التفعيل عبر إعلان بمكافأة؟',
    'Watch a short ad to enable this training option. It turns on only after the reward is confirmed.':
        'شاهد إعلانًا قصيرًا لتفعيل خيار التدريب. لن يعمل إلا بعد تأكيد المكافأة.',
    'Not now': 'ليس الآن',
    'Watch ad': 'مشاهدة الإعلان',
    'Feature enabled': 'تم تفعيل الميزة',
    'Ad is not ready. Try again soon.':
        'الإعلان غير جاهز. حاول مجددًا بعد قليل.',
    'AppLovin may receive device and ad-interaction data to deliver and measure ads. Your ATT choice controls cross-app tracking on Apple devices. For details about AppLovin’s collection and use of information, visit:':
        'قد تتلقى AppLovin بيانات الجهاز والتفاعل مع الإعلانات لعرضها وقياسها. يتحكم اختيار ATT في التتبع بين التطبيقات على أجهزة Apple. لمعرفة المزيد عن جمع AppLovin للمعلومات واستخدامها، تفضل بزيارة:',
    'AppLovin Privacy Policy': 'سياسة خصوصية AppLovin',
    'Settings': 'الإعدادات',
    'Privacy Policy': 'سياسة الخصوصية',
    'How your local app data is handled':
        'كيفية التعامل مع بيانات التطبيق المحلية',
    'Share App': 'مشاركة التطبيق',
    'Tell someone about Aura Aim': 'أخبر شخصًا عن Aura Aim',
    'Rate App': 'قيّم التطبيق',
    'Open the app store page': 'فتح صفحة المتجر',
    'Reset all progress': 'إعادة تعيين كل التقدم',
    'Clear scores, lessons, streaks, and toggles':
        'مسح النتائج والدروس والسلاسل والخيارات',
    'About': 'حول التطبيق',
    'Version and app details': 'الإصدار وتفاصيل التطبيق',
    'Language': 'اللغة',
    'Choose the language used throughout the app':
        'اختر اللغة المستخدمة في التطبيق بالكامل',
    'Reset all progress?': 'هل تريد إعادة تعيين كل التقدم؟',
    'Cancel': 'إلغاء',
    'Reset everything': 'إعادة تعيين الكل',
    'All progress cleared': 'تم مسح كل التقدم',
    'Your Practice Snapshot': 'ملخص تدريبك',
    'DAILY STREAK': 'سلسلة الأيام',
    'DRILLS DONE': 'التدريبات المكتملة',
    'LESSONS': 'الدروس',
    'days': 'أيام',
    'Practice profile enabled': 'ملف التدريب مفعّل',
    'Tap to enable practice profile': 'اضغط لتفعيل ملف التدريب',
    'SENSI RESULT': 'نتيجة الحساسية',
    'Scale 0 to 200': 'المقياس من 0 إلى 200',
    'GENERATED': 'تم الإنشاء',
    'SAMPLE PREVIEW': 'معاينة تجريبية',
    'Sensitivity Generator (simulated)': 'مولّد الحساسية (محاكاة)',
    'Device type': 'نوع الجهاز',
    'Play style': 'أسلوب اللعب',
    'Low-end': 'منخفض',
    'Mid-range': 'متوسط',
    'High-end': 'متقدم',
    'Tablet': 'جهاز لوحي',
    'Defensive': 'دفاعي',
    'Balanced': 'متوازن',
    'Aggressive': 'هجومي',
    'GENERATE': 'إنشاء',
    'GENERATING...': 'جارٍ الإنشاء...',
    'Copy': 'نسخ',
    'Copied simulated values': 'تم نسخ القيم التجريبية',
    'General': 'عام',
    'Red Dot': 'النقطة الحمراء',
    'Device Info (sample data)': 'معلومات الجهاز (بيانات نموذجية)',
    'Live Performance (simulated)': 'الأداء المباشر (محاكاة)',
    'iPhone model · choose manually': 'طراز iPhone · اختيار يدوي',
    'Sample baseline': 'قيمة أساسية تجريبية',
    'TRAIN WITH INTENTION': 'تدرّب بهدف',
    'Short practice rounds for timing, control, and precision.':
        'جولات تدريب قصيرة للتوقيت والتحكم والدقة.',
    'Round length': 'مدة الجولة',
    'Easy': 'سهل',
    'Medium': 'متوسط',
    'Hard': 'صعب',
    'Start': 'ابدأ',
    'Trains': 'يدرّب',
    'BEST': 'الأفضل',
    'Learning Progress': 'تقدم التعلم',
    'lessons complete': 'دروس مكتملة',
    'Complete': 'مكتمل',
    'Key takeaways': 'أهم النقاط',
    'Try this drill': 'جرّب هذا التدريب',
    'minute read': 'دقيقة قراءة',
    'SAVING...': 'جارٍ الحفظ...',
    'MARK AS COMPLETE': 'وضع علامة مكتمل',
    'MARK AS INCOMPLETE': 'إلغاء علامة الاكتمال',
    'YOUR PROGRESS': 'تقدمك',
    'A look at the practice you have put in.': 'نظرة على ما أنجزته من تدريب.',
    'SESSIONS': 'الجلسات',
    'BEST SCORE': 'أفضل نتيجة',
    'STREAK': 'السلسلة',
    'Score progress': 'تطور النتائج',
    'Your 12 most recent drill results': 'أحدث 12 نتيجة تدريب',
    'Complete a drill to start your progress curve.':
        'أكمل تدريبًا لبدء منحنى تقدمك.',
    'Complete another drill to see your curve.':
        'أكمل تدريبًا آخر لرؤية المنحنى.',
    'DRILL SCORE': 'نتيجة التدريب',
    'Learning progress': 'تقدم التعلم',
    'YOUR PRACTICE STAYS YOURS': 'تدريبك يبقى ملكك',
    'Plain-language policy': 'سياسة بلغة واضحة',
    'SIM': 'محاكاة',
    'No active options': 'لا توجد خيارات مفعّلة',
    'Tap Target': 'النقر على الهدف',
    'Reaction Test': 'اختبار رد الفعل',
    'Flick Shots': 'التصويب السريع',
    'Tracking': 'التتبع',
    'Micro-Adjust': 'تصحيح دقيق',
    'Target Switching': 'تبديل الأهداف',
    'Peek Shot': 'التصويب الخاطف',
    'Recoil Control': 'التحكم بالارتداد',
    'Precision': 'الدقة',
    'Reaction': 'رد الفعل',
    'Control': 'التحكم',
    'Awareness': 'الوعي',
    'Practice': 'التدريب',
    'Foundations': 'الأساسيات',
    'DRILL COMPLETE': 'اكتمل التدريب',
    'SCORE': 'النتيجة',
    'NEW BEST': 'أفضل نتيجة جديدة',
    'BACK': 'رجوع',
    'RETRY': 'إعادة',
    'Sensi Setup': 'إعداد الحساسية',
    'Ball Setup': 'إعداد الكرة',
    'Crosshair': 'علامة التصويب',
    'Controls': 'عناصر التحكم',
    'Display': 'الشاشة',
    'Training Habits': 'عادات التدريب',
    'Mobile Sensi': 'حساسية الهاتف',
    'Emu Sensi': 'حساسية المحاكي',
    'HUD Phone': 'واجهة الهاتف',
    'Device DPI': 'كثافة الجهاز',
    'AI Sensi and Aim': 'حساسية وتصويب بالذكاء الاصطناعي',
    'Aim Lock Practice Cue': 'مؤشر تثبيت التصويب',
    'Gyroscope Aim': 'التصويب بالجيروسكوب',
    'Custom HUD Layout': 'تخطيط واجهة مخصص',
    'Fire Button Size': 'حجم زر الإطلاق',
    '4-Finger Claw Layout': 'تخطيط أربعة أصابع',
    'FPS': 'الإطارات',
    'RAM': 'الذاكرة',
    'Ping Live': 'زمن الاتصال المباشر',
    'Show an in-app FPS reading (simulated)':
        'عرض قراءة إطارات داخل التطبيق (محاكاة)',
    'Show an in-app RAM reading (simulated)':
        'عرض قراءة ذاكرة داخل التطبيق (محاكاة)',
    'Show an in-app ping reading (simulated)':
        'عرض قراءة اتصال داخل التطبيق (محاكاة)',
    'High Frame Rate Mode': 'وضع معدل إطارات مرتفع',
    'Smooth Graphics': 'رسومات سلسة',
    'Screen Brightness Lock Reminder': 'تذكير سطوع الشاشة',
    'Daily Warm-up Reminder': 'تذكير إحماء يومي',
    'Haptic Feedback': 'استجابة لمسية',
    'Sound Effects': 'مؤثرات صوتية',
    'Show Hit Markers in Drills': 'إظهار علامات الإصابة',
    'Ball Overlay': 'طبقة الكرة',
    'Crosshair Overlay': 'طبقة علامة التصويب',
    'Reset checklist': 'إعادة تعيين القائمة',
    'These toggles track your own setup. Nothing in your phone or game is changed.':
        'تتابع هذه الخيارات إعدادك الشخصي. لا يتغير أي إعداد في الهاتف أو اللعبة.',
    'Finding Your Sensitivity': 'اختيار الحساسية المناسبة',
    'Crosshair Placement': 'موضع علامة التصويب',
    'Thumb and Finger Mechanics': 'حركة الإبهام والأصابع',
    'Flick vs Tracking': 'النقلة السريعة والتتبع',
    'Recoil and Burst Control': 'التحكم بالارتداد والدفعات',
    'Scope Handling': 'التعامل مع المنظار',
    'Warm-up Routine': 'روتين الإحماء',
    'Mindset and Consistency': 'العقلية والاستمرارية',
    'min read': 'دقيقة قراءة',
    'lessons completed': 'دروس مكتملة',
    'of': 'من',
    'sec': 'ث',
    'ready': 'جاهزة',
    'Selected practice preferences activated in Training':
        'تم تفعيل تفضيلات التدريب المحددة',
    'Nothing on your phone or in a game is changed.':
        'لا يتم تغيير أي إعداد في الهاتف أو اللعبة.',
    'Simulated values are for demonstration only.':
        'القيم المحاكية للعرض التوضيحي فقط.',
    'Take a break during long sessions. Look away from the screen and relax your hands and eyes.':
        'خذ استراحة في الجلسات الطويلة. انظر بعيدًا عن الشاشة وأرح يديك وعينيك.',
    'This clears your drill scores and history, lesson completion, and setup checklist.':
        'سيؤدي هذا إلى مسح نتائج التدريب وسجله والدروس المكتملة وقائمة الإعداد.',
    'Your practice checklist, lesson progress, drill scores, and history are stored on this device. AppLovin may receive device and ad-interaction data to deliver and measure ads. Your ATT choice controls cross-app tracking on Apple devices. Sample device and performance values are made up. The app does not read or change game or phone settings.':
        'تُحفظ قائمة التدريب وتقدم الدروس والنتائج والسجل على هذا الجهاز. قد تتلقى AppLovin بيانات الجهاز والتفاعل مع الإعلانات لعرضها وقياسها. يتحكم اختيار ATT في التتبع بين التطبيقات على أجهزة Apple. بيانات الجهاز والأداء تجريبية. لا يقرأ التطبيق إعدادات الهاتف أو اللعبة ولا يغيّرها.',
    'You can reset all saved data at any time from Settings. Resetting removes the app’s locally stored progress and preferences.':
        'يمكنك مسح البيانات المحفوظة من الإعدادات في أي وقت. يؤدي ذلك إلى حذف التقدم والتفضيلات المخزنة محليًا.',
    'Ball color preference': 'تفضيل لون الكرة',
    'Preferred ball size': 'حجم الكرة المفضل',
    'Hide / turn off': 'إخفاء / إيقاف',
    'Crosshair color': 'لون علامة التصويب',
    'Settings · Pro Crosshair': 'الإعدادات · علامة احترافية',
    'Touch sensitivity': 'حساسية اللمس',
    'Emulator sensitivity note': 'ملاحظة حساسية المحاكي',
    'Preferred device DPI note': 'ملاحظة كثافة الجهاز',
    'Practice sensitivity note': 'ملاحظة حساسية التدريب',
    'Gyro practice sensitivity': 'حساسية الجيروسكوب للتدريب',
    'Fire button size': 'حجم زر الإطلاق',
    'Brightness reminder': 'تذكير السطوع',
    'Warm-up length': 'مدة الإحماء',
    'Phone HUD spacing': 'تباعد واجهة الهاتف',
    'Layout preset note': 'ملاحظة التخطيط',
    'Finger layout note': 'ملاحظة تخطيط الأصابع',
    'Frame-rate target note': 'ملاحظة هدف الإطارات',
    'Graphics preference': 'تفضيل الرسومات',
    'Saved preference only · no ball is drawn in Training':
        'تفضيل محفوظ فقط؛ لا تظهر كرة في التدريب',
    'Compact': 'مضغوط',
    'Reach': 'مدى الوصول',
    'Thumbs': 'الإبهامان',
    'Claw': 'مخلب',
    'Three fingers': 'ثلاثة أصابع',
    'Four fingers': 'أربعة أصابع',
    'Quality': 'جودة',
    'Classic': 'كلاسيكي',
    'Dot': 'نقطة',
    'Circle': 'دائرة',
    'T-Shape': 'شكل T',
    'PRO': 'احترافي',
    'Targets per minute': 'أهداف في الدقيقة',
    'Tap single targets with calm, accurate placement.':
        'انقر أهدافًا منفردة بهدوء ودقة.',
    'Wait for the cue, then respond without rushing.':
        'انتظر الإشارة واستجب دون استعجال.',
    'Move quickly from center to a far target.':
        'انتقل بسرعة من الوسط إلى هدف بعيد.',
    'Hold and follow a moving target with control.':
        'المس وتابع هدفًا متحركًا بتحكم.',
    'Make small corrections between close targets.':
        'أجرِ تصحيحات صغيرة بين الأهداف القريبة.',
    'Shift attention between numbered target positions.':
        'حوّل انتباهك بين الأهداف المرقمة.',
    'React to a brief target appearance.': 'استجب لظهور الهدف لفترة قصيرة.',
    'Drag smoothly against the target drift.': 'اسحب بسلاسة عكس انجراف الهدف.',
    'Hold and drag to follow the target': 'المس واسحب لمتابعة الهدف',
    'Your chosen touch sensitivity': 'حساسية اللمس التي اخترتها',
    'Your emulator preference': 'تفضيل المحاكي',
    'Your phone control layout': 'تخطيط تحكم الهاتف',
    'Your personal DPI note': 'ملاحظتك الشخصية لكثافة DPI',
    'Your practice sensitivity preference': 'تفضيل حساسية التدريب',
    'Optional visual focus cue in drills': 'مؤشر تركيز بصري اختياري في التدريب',
    'Your gyro preference': 'تفضيل الجيروسكوب',
    'Your button arrangement': 'ترتيب الأزرار',
    'Your preferred button size': 'حجم الزر المفضل',
    'Your finger layout preference': 'تفضيل تخطيط الأصابع',
    'Show a made-up in-app FPS reading': 'عرض معدل إطارات افتراضي داخل التطبيق',
    'Show a made-up in-app RAM reading': 'عرض ذاكرة افتراضية داخل التطبيق',
    'Show a made-up in-app ping reading': 'عرض زمن اتصال افتراضي داخل التطبيق',
    'Reminder for your own setup': 'تذكير لإعدادك الشخصي',
    'Your graphics preference': 'تفضيل الرسومات',
    'A personal reminder': 'تذكير شخصي',
    'Your habit checklist': 'قائمة عاداتك',
    'Feedback inside training drills': 'استجابة داخل التدريبات',
    'Visual drill feedback': 'استجابة مرئية في التدريب',
    'Saved overlay preference only': 'تفضيل طبقة محفوظ فقط',
    'Show or hide your training reticle':
        'إظهار أو إخفاء علامة التصويب التدريبية',
    'Write down your current values, then test one small adjustment at a time.':
        'دوّن قيمك الحالية واختبر تعديلًا صغيرًا في كل مرة.',
    'Keep a separate note for emulator play so the two setups do not get mixed.':
        'احتفظ بملاحظة منفصلة للمحاكي حتى لا تختلط الإعدادات.',
    'Place frequently used controls where your fingers can reach without stretching.':
        'ضع عناصر التحكم المتكررة ضمن مدى أصابعك المريح.',
    'Treat DPI as a note for your setup. This checklist never changes device display settings.':
        'اعتبر DPI ملاحظة لإعدادك؛ هذه القائمة لا تغيّر إعدادات الشاشة.',
    'Adjust this saved practice note gradually. It does not control aim in a game.':
        'عدّل ملاحظة التدريب تدريجيًا؛ فهي لا تتحكم بالتصويب في اللعبة.',
    'This preference is for a visual focus cue in this app only; it never locks aim or controls a game.':
        'هذا التفضيل لمؤشر بصري داخل التطبيق فقط ولا يثبت التصويب أو يتحكم باللعبة.',
    'This is a generated demonstration value. The app does not read device frame rate.':
        'هذه قيمة توضيحية مولدة؛ التطبيق لا يقرأ معدل الإطارات.',
    'This is a generated demonstration value. The app does not inspect device memory.':
        'هذه قيمة توضيحية مولدة؛ التطبيق لا يفحص ذاكرة الجهاز.',
    'This is a generated demonstration value. The app does not connect to a server or measure network latency.':
        'هذه قيمة توضيحية مولدة؛ التطبيق لا يتصل بخادم ولا يقيس زمن الشبكة.',
    'Home': 'الرئيسية',
    'Training': 'التدريب',
    'Device': 'الجهاز',
    'Learn': 'التعلم',
    'Stats': 'الإحصاءات',
    'TIME': 'الوقت',
    'ROUND': 'الجولة',
    'HIT': 'الإصابات',
    'Accuracy': 'الدقة',
    'Average reaction': 'متوسط رد الفعل',
    'Best reaction': 'أفضل رد فعل',
    'Average time to hit': 'متوسط زمن الإصابة',
    'Turn practice profile off': 'إيقاف ملف التدريب',
    'Turn practice profile on': 'تفعيل ملف التدريب',
    'Activate at least one feature': 'فعّل ميزة واحدة على الأقل',
    'Aim Trainer': 'مدرب التصويب',
    'Speed': 'السرعة',
    'Moving': 'متحركة',
    'Daily': 'يومي',
    'One target at a time. Steady pace.': 'هدف واحد في كل مرة وبإيقاع ثابت.',
    'Targets vanish fast. Stay sharp.':
        'تختفي الأهداف بسرعة، فحافظ على تركيزك.',
    'Small targets. Accuracy matters.': 'أهداف صغيرة؛ الدقة مهمة.',
    'Two bouncing targets at once.': 'هدفان متحركان في الوقت نفسه.',
    'Same target layout for everyone today.': 'نمط الأهداف نفسه للجميع اليوم.',
    'Direct tap': 'نقر مباشر',
    'Drag + Fire': 'اسحب وأطلق',
    'Drag speed': 'سرعة السحب',
    'from your General sensitivity slider': 'بحسب شريط الحساسية العامة',
    'Stop': 'إيقاف',
    'Play again': 'العب مجددًا',
    'Lifetime': 'الإجمالي',
    'Sessions': 'الجلسات',
    'Total hits': 'مجموع الإصابات',
    'Best streak': 'أفضل سلسلة',
    'Personal bests': 'أفضل النتائج الشخصية',
    'Recent scores': 'النتائج الأخيرة',
    'Achievements': 'الإنجازات',
    'Play two sessions to see your trend.': 'أكمل جلستين لرؤية منحنى تقدمك.',
    'First Blood': 'الإصابة الأولى',
    'Finish your first session': 'أكمل جلستك الأولى',
    'Sharpshooter': 'قناص دقيق',
    '90% accuracy with 20+ shots': 'دقة 90٪ مع 20 طلقة أو أكثر',
    'Quick Draw': 'سحب سريع',
    'Average under 600 ms (10+ hits)':
        'متوسط أقل من 600 مللي ثانية (10 إصابات أو أكثر)',
    'On Fire': 'متألق',
    'Hit a streak of 15': 'حقق سلسلة من 15 إصابة',
    'Centurion': 'المئوي',
    '100 total hits': '100 إصابة إجمالًا',
    'Profile Hopper': 'متنقل بين الملفات',
    'Play with 3 different profiles': 'العب باستخدام 3 ملفات مختلفة',
    'FPS · SIM': 'إطارات · تجريبي',
    'RAM · SIM': 'ذاكرة · تجريبي',
    'PING · SIM': 'زمن الشبكة · تجريبي',
    'Press Start': 'اضغط ابدأ',
    'FIRE': 'إطلاق',
    'NEW PERSONAL BEST': 'أفضل نتيجة شخصية جديدة',
    'pts': 'نقطة',
    'Avg reaction': 'متوسط الاستجابة',
    'Best': 'الأفضل',
    'Hits': 'الإصابات',
    'Misses': 'الإخفاقات',
    'Escaped': 'أهداف فائتة',
    'Reaction time per hit': 'زمن الاستجابة لكل إصابة',
    'Cross': 'تقاطع',
    'Plus': 'زائد',
    'Profiles': 'الملفات',
    'saved': 'محفوظة',
    'Swipe a card to switch. Crosshair and sensitivity change instantly.':
        'اسحب للتبديل بين الملفات. يتغير التصويب والحساسية فورًا.',
    'No profiles yet. Tap "Save current setup" to create one.':
        'لا توجد ملفات بعد. اضغط "حفظ الإعداد الحالي" لإنشاء ملف.',
    'Unsaved changes on': 'تغييرات غير محفوظة في',
    'Revert': 'تراجع',
    'Update profile': 'تحديث الملف',
    'Tune active profile': 'ضبط الملف النشط',
    'Manage': 'إدارة',
    'Save current setup': 'حفظ الإعداد الحالي',
    'Import from code': 'استيراد من رمز',
    'Profile Lab': 'مختبر الملفات',
    'Crosshair style': 'نمط علامة التصويب',
    'Sensitivity': 'الحساسية',
    'Play the Aim Trainer with different profiles to see which setup scores best.':
        'جرّب ملفات مختلفة في مدرب التصويب لمعرفة الأفضل نتيجة.',
    'ACTIVE': 'نشط',
    'sessions': 'جلسات',
    'No trainer score yet': 'لا توجد نتيجة تدريب بعد',
    'Rename': 'إعادة تسمية',
    'Duplicate': 'نسخ',
    'Share code / QR': 'مشاركة الرمز / QR',
    'Drill library': 'مكتبة التدريبات',
    'Monitor': 'المراقبة',
    'My setup': 'إعدادي',
    'Imported': 'مستورد',
    'Rename profile': 'إعادة تسمية الملف',
    'This cannot be undone.': 'لا يمكن التراجع عن هذا الإجراء.',
    'Share': 'مشاركة',
    'Code copied': 'تم نسخ الرمز',
    'Copy code': 'نسخ الرمز',
    'Close': 'إغلاق',
    'Import profile': 'استيراد ملف',
    'Paste an FFP1: code': 'ألصق رمز FFP1:',
    'Paste': 'لصق',
    'Import': 'استيراد',
    'Profile name': 'اسم الملف',
    'Size': 'الحجم',
    'Thickness': 'السماكة',
    'Gap': 'الفجوة',
    'Opacity': 'العتامة',
    'Save': 'حفظ',
    'That is not a valid Aura profile code.': 'رمز ملف Aura هذا غير صالح.',
    'Haptic tap on hits and misses while the practice profile is ON':
        'يهتز عند الإصابة والإخفاق مع تفعيل ملف التدريب',
    'System click on hits and misses while the practice profile is ON':
        'يصدر نقرة النظام عند الإصابة والإخفاق مع تفعيل الملف',
    'When enabled, the active practice profile gives a medium haptic on a hit and a light haptic on a miss.':
        'مع تفعيل ملف التدريب، تكون الهزة متوسطة عند الإصابة وخفيفة عند الإخفاق.',
    'When enabled, the active practice profile plays the device system click after hits and misses.':
        'مع تفعيل ملف التدريب، يصدر صوت نقرة النظام بعد الإصابة والإخفاق.',
    'Hits use a medium vibration; misses use a lighter vibration while the practice profile is on.':
        'تستخدم الإصابة هزة متوسطة والإخفاق هزة أخف عند تفعيل ملف التدريب.',
    'A short system click plays after hits and misses while the practice profile is on.':
        'تصدر نقرة قصيرة من النظام بعد الإصابة والإخفاق مع تفعيل ملف التدريب.',
    'Model': 'الطراز',
    'Platform': 'النظام',
    'iOS version': 'إصدار iOS',
    'Display size': 'حجم الشاشة',
    'Display refresh': 'تحديث الشاشة',
    'Preset source': 'مصدر الملف',
    'iPhone · manual selection': 'iPhone · اختيار يدوي',
    'Not read · sample panel': 'غير مقروء · لوحة نموذجية',
    'Illustrative estimate': 'تقدير توضيحي',
    'Illustrative starting point only. Apple and games do not publish universal per-iPhone aim sensitivity values; tune these in your own game.':
        'قيمة إرشادية فقط. لا توجد حساسية موحدة لكل iPhone؛ اضبطها في لعبتك.',
    'Sensitivity varies by game and player.':
        'تختلف الحساسية حسب اللعبة واللاعب.',
    'Aura Aim keeps its promises simple.': 'تلتزم Aura Aim بوعود بسيطة.',
    'Stats use practice history saved inside this app.':
        'تعتمد الإحصاءات على سجل التدريب المحفوظ في التطبيق.',
    'Your control layout': 'تخطيط تحكمك',
    'If you use gyro, try gentle tilts first and keep your wrists relaxed.':
        'إن استخدمت الجيروسكوب، ابدأ بإمالة خفيفة وأرح معصميك.',
    'Choose a size that is easy to tap without blocking your view.':
        'اختر حجمًا يسهل لمسه دون حجب الرؤية.',
    'Build up gradually. Stop if a position causes discomfort or strain.':
        'تدرّج وتوقف إذا سببت الوضعية انزعاجًا أو إجهادًا.',
    'Check the game menu yourself and choose a mode that stays smooth on your device.':
        'افحص قائمة اللعبة واختر وضعًا سلسًا على جهازك.',
    'A consistent picture can make target movement easier to read.':
        'ثبات الصورة يسهل ملاحظة حركة الهدف.',
    'Set a comfortable brightness before a session and avoid glare.':
        'اضبط سطوعًا مريحًا وتجنب الانعكاس.',
    'Start with a few minutes of easy, controlled practice before raising difficulty.':
        'ابدأ بدقائق من التدريب السهل قبل رفع الصعوبة.',
    'When enabled, supported drills use a short vibration on a hit.':
        'عند التفعيل، تهتز بعض التدريبات قليلًا عند الإصابة.',
    'When enabled, supported drills play a light system click on a hit.':
        'عند التفعيل، تصدر بعض التدريبات نقرة خفيفة عند الإصابة.',
    'Hit markers can help you notice successful timing during practice.':
        'تساعد علامات الإصابة على ملاحظة التوقيت الناجح.',
    'Choose whether your ball overlay preference is on or hidden. This app saves the setting but never draws a ball in Training.':
        'اختر تفضيل طبقة الكرة. يحفظ التطبيق الخيار لكنه لا يرسم كرة في التدريب.',
    'Switch this on to use your chosen crosshair color and Pro Crosshair style in drills.':
        'فعّل هذا لاستخدام لون ونمط علامة التصويب المختارين في التدريب.',
    'TAP!': 'انقر!',
    'WAIT': 'انتظر',
  },
};

const _lessonTranslations = <String, Map<String, String>>{
  'pt': {
    'sensitivity:0':
        'Sensibilidade é uma preferência pessoal: procure um valor que permita mover a mira com intenção e parar onde deseja. Teste o gerador de amostras apenas como referência; os números são simulados e não recomendam configurações para um jogo ou aparelho específico.',
    'sensitivity:1':
        'Altere uma coisa por vez. Faça um pequeno ajuste e repita o mesmo movimento por alguns minutos. Observe se costuma parar antes, passar do alvo ou manter o controle. Anote o valor e a sensação para comparar sem depender da memória.',
    'sensitivity:2':
        'Evite mudar a sensibilidade após cada partida difícil. Atenção, pegada, descanso e situação afetam o resultado. Dê tempo para se acostumar antes de decidir. Mudar vários controles juntos dificulta saber o que ajudou; conforto e consistência importam mais que copiar números de outra pessoa.',
    'crosshair:0':
        'A boa mira começa antes de um alvo aparecer. Mantenha a mira perto da altura provável do adversário para reduzir o movimento necessário. Ao avançar, imagine as aberturas possíveis e direcione a visão com calma. Essa preparação dá mais tempo para reagir.',
    'crosshair:1':
        'Use referências como batentes, bordas e mudanças no chão para manter uma altura consistente. Ao chegar a um canto, aponte além da borda que pretende observar e avance em um ritmo que permita verificar cada abertura. A posição inicial determina quanto será preciso corrigir.',
    'crosshair:2':
        'No treino de disparos rápidos, volte ao centro entre os alvos. Comece cada movimento de uma altura útil e pare com controle. Depois, revise quando sua primeira correção foi grande demais. Uma boa posição não garante acerto, mas facilita a decisão seguinte.',
    'mechanics:0':
        'Seu layout deve combinar com suas mãos, o tamanho do aparelho e um alcance confortável. Algumas pessoas preferem usar os polegares; outras adicionam dedos para não interromper uma tarefa. Nenhum formato é sempre melhor. O importante é repetir sem apertar o aparelho ou esticar os dedos.',
    'mechanics:1':
        'Ao testar mais dedos, mude uma coisa por vez em um ambiente seguro. Mantenha a pegada relaxada e posicione os botões onde os dedos descansam naturalmente. Se os dedos se chocarem ou a precisão cair, simplifique e tente de novo mais tarde.',
    'mechanics:2':
        'Faça correções pequenas e controladas, deixando a mão descansar entre repetições. O treino Microajuste ajuda a praticar movimentos sutis. Mantenha as sessões curtas e pare se sentir rigidez ou dor. Mudar a postura nas pausas pode tornar a prática mais confortável.',
    'flick-tracking:0':
        'Um flick é um movimento curto e decidido até o alvo, útil quando ele aparece por pouco tempo ou está longe da mira. Rastreamento é uma correção contínua para acompanhar algo em movimento. Cada técnica tem um ritmo próprio; uma não substitui a outra em todas as situações.',
    'flick-tracking:1':
        'Pratique cada habilidade separadamente. Nos disparos rápidos, observe se começa do centro e para sobre o alvo. No rastreamento, mantenha o movimento suave sem perseguir cada pequena mudança. O objetivo é ficar próximo do alvo, não fazer um movimento exagerado.',
    'flick-tracking:2':
        'Durante uma partida, considere distância, visibilidade e movimento. Um alvo que cruza rapidamente pode pedir um flick controlado; um movimento constante pode ser acompanhado. Também é possível reposicionar a mira e depois rastrear. Use os erros observados para escolher um foco para a próxima sessão.',
    'recoil:0':
        'Disparos repetidos podem afastar a visão do ponto inicial. Uma correção suave e medida costuma ser mais controlável que um puxão brusco. O treino de recuo usa um alvo simples em movimento para praticar, sem representar uma arma ou jogo específico.',
    'recoil:1':
        'Rajadas curtas permitem observar e reiniciar a mira. Faça alguns disparos, pause e veja onde ela parou. Se subiu demais, ajuste suavemente; se puxou demais para baixo, reduza a correção. Os controles variam, então observar é mais útil que memorizar padrões alheios.',
    'recoil:2':
        'Mantenha a mão solta e a visão estável. O controle depende do tempo e do padrão observado, não apenas de puxar em uma direção. Pratique com calma e pare antes do cansaço. Reiniciar a mira entre rajadas ajuda a recuperar uma posição confortável.',
    'scope:0':
        'O zoom muda o campo de visão e o efeito de pequenos movimentos. Ao aumentar o zoom, estabilize a visão, localize o alvo e faça uma correção deliberada. Dê aos olhos um instante para se adaptar antes de acelerar.',
    'scope:1':
        'Cada ampliação pode pedir uma sensibilidade própria no jogo, mas não existe fórmula universal. Os números do gerador são dados de amostra simulados. Compare um nível de zoom por vez com o mesmo movimento e procure controle repetível, não apenas velocidade.',
    'scope:2':
        'Respirar com calma pode ajudar antes de uma ação precisa. Relaxe os ombros e evite prender a respiração. Uma expiração tranquila pode reduzir tensão nas mãos. Se a visão parecer instável, ajuste a postura, diminua o ritmo ou faça uma pausa.',
    'warmup:0':
        'Um aquecimento deve preparar sua atenção sem cansar. Experimente dez minutos: dois de Alvo de toque, dois de Teste de reação, dois de Disparos rápidos, dois de Rastreamento e dois repetindo o movimento menos confortável. Mantenha a dificuldade leve.',
    'warmup:1':
        'Faça pequenas pausas entre treinos. Observe a pegada e a concentração. Se estiver com pressa, desacelere a próxima repetição. A lista da tela inicial apenas registra suas preferências; ela não verifica nem configura o celular ou o jogo.',
    'warmup:2':
        'Adapte a rotina ao tempo e à energia disponíveis. Não é necessário fazer todos os treinos diariamente. Em um dia cansativo, escolha uma sessão curta ou descanse. Termine anotando algo que foi controlado e algo para observar na próxima vez.',
    'mindset:0':
        'Uma sequência de derrotas pode fazer cada erro parecer prova de que tudo está errado. Antes de mudar várias coisas, reveja um momento: onde estava sua atenção, o que esperava e o que tentaria diferente? Anotações específicas ajudam; críticas pessoais não.',
    'mindset:1':
        'Sessões curtas criam consistência e deixam espaço para recuperação. Escolha um objetivo simples, como parar a mira com precisão ou manter a mão relaxada. Quando conseguir, encerre. Se perder o foco ou ficar frustrado, pare em vez de forçar.',
    'mindset:2':
        'Em sessões longas, cuide das mãos e dos olhos. Olhe para longe, pisque, mude de postura e relaxe as mãos. Pare se sentir dor, dormência ou esforço incomum. O histórico registra sua prática, não seu valor. Voltar descansado costuma ser melhor que insistir cansado.'
  },
  'es': {
    'sensitivity:0':
        'La sensibilidad es personal: busca un valor que te permita mover la mira con intención y detenerla donde querías. Usa el generador de muestras solo como referencia; sus números son simulados y no recomiendan ajustes para un juego o dispositivo concreto.',
    'sensitivity:1':
        'Cambia una sola cosa cada vez. Haz un ajuste pequeño y repite el mismo movimiento durante unos minutos. Observa si te quedas corto, te pasas o mantienes el control. Anota el valor y cómo se siente para poder comparar sin depender de la memoria.',
    'sensitivity:2':
        'Evita cambiar la sensibilidad después de cada partida difícil. La atención, el agarre, el descanso y la situación influyen. Date tiempo para acostumbrarte. Cambiar varios controles a la vez dificulta saber qué ayudó; la comodidad y la constancia importan más que copiar números ajenos.',
    'crosshair:0':
        'La buena puntería empieza antes de que aparezca un objetivo. Mantén la mira cerca de la altura probable del rival para reducir el recorrido de la mano. Al avanzar, imagina las aperturas posibles y dirige la vista con calma. Esta preparación te da más tiempo para reaccionar.',
    'crosshair:1':
        'Usa referencias como marcos, bordes y cambios del suelo para mantener una altura constante. Al acercarte a una esquina, apunta un poco más allá del borde que vas a revisar y avanza a un ritmo que permita observar cada abertura.',
    'crosshair:2':
        'En Disparos rápidos, vuelve al centro entre objetivos. Empieza cada movimiento desde una altura útil y detente con control. Después revisa cuándo tu primera corrección fue demasiado grande. Una buena posición no garantiza el acierto, pero facilita la siguiente decisión.',
    'mechanics:0':
        'Tu diseño de controles debe adaptarse a tus manos, al tamaño del móvil y a un alcance cómodo. Algunas personas prefieren los pulgares; otras añaden dedos para separar tareas. Ningún diseño es siempre mejor. Lo importante es repetirlo sin apretar ni estirar la mano.',
    'mechanics:1':
        'Al probar más dedos, cambia una cosa cada vez en un entorno seguro. Mantén el agarre relajado y coloca los botones donde descansan los dedos. Si chocan o pierdes precisión, simplifica el diseño y vuelve a probar más adelante.',
    'mechanics:2':
        'Haz correcciones pequeñas y controladas, dejando que la mano descanse entre repeticiones. Microajuste practica esos movimientos sutiles. Mantén las sesiones breves y para si notas rigidez o dolor. Cambiar de postura en las pausas puede hacer la práctica más cómoda.',
    'flick-tracking:0':
        'Un flick es un movimiento corto y decidido hacia un objetivo, útil si aparece poco tiempo o está lejos de la mira. El seguimiento es una corrección continua para acompañar algo en movimiento. Cada técnica tiene su ritmo y ninguna sirve igual en todas las situaciones.',
    'flick-tracking:1':
        'Practica cada habilidad por separado. En Disparos rápidos, observa si partes del centro y te detienes sobre el objetivo. En Seguimiento, mantén el movimiento suave sin perseguir cada cambio pequeño. La meta es mantenerte cerca, no hacer un barrido exagerado.',
    'flick-tracking:2':
        'En una partida, considera la distancia, la visibilidad y el movimiento. Un objetivo que cruza rápido puede pedir un flick controlado; uno constante puede ser más fácil de seguir. También puedes recolocar la mira y luego seguirlo. Usa tus observaciones para elegir el próximo foco.',
    'recoil:0':
        'Los disparos repetidos pueden alejar la vista del punto inicial. Una corrección suave y medida suele controlarse mejor que un tirón brusco. El ejercicio de retroceso usa un objetivo sencillo en movimiento y no representa un arma ni un juego concreto.',
    'recoil:1':
        'Las ráfagas cortas permiten observar y reiniciar la mira. Dispara un grupo pequeño, haz una pausa y comprueba dónde quedó. Si subió demasiado, corrige con suavidad; si bajaste de más, reduce el movimiento. Observar es más útil que memorizar patrones ajenos.',
    'recoil:2':
        'Mantén la mano relajada y la vista estable. El control depende del ritmo y del patrón que observes, no solo de tirar en una dirección. Practica con calma y para antes de cansarte. Reiniciar la mira entre ráfagas ayuda a recuperar una posición cómoda.',
    'scope:0':
        'El zoom cambia el campo visual y el efecto de los movimientos pequeños. Al usar más zoom, estabiliza la vista, localiza el objetivo y corrige con intención. Deja que los ojos se adapten un momento antes de acelerar.',
    'scope:1':
        'Cada aumento puede necesitar una sensibilidad distinta en tu juego, pero no hay una fórmula universal. Los valores del generador son muestras simuladas. Compara un nivel de zoom cada vez con el mismo movimiento y busca control repetible, no solo velocidad.',
    'scope:2':
        'Respirar con calma puede ayudarte antes de una acción precisa. Relaja los hombros y evita aguantar el aire. Una exhalación tranquila puede reducir la tensión en las manos. Si la vista tiembla, reajusta la postura, baja el ritmo o descansa.',
    'warmup:0':
        'El calentamiento prepara la atención sin agotarte. Prueba diez minutos: dos de Toque al objetivo, dos de Prueba de reacción, dos de Disparos rápidos, dos de Seguimiento y dos repitiendo el movimiento menos cómodo. Mantén una dificultad fácil.',
    'warmup:1':
        'Haz transiciones breves entre ejercicios. Observa el agarre y la concentración. Si tienes prisa, ralentiza la siguiente repetición. La lista de Inicio solo registra preferencias; no revisa ni configura el móvil o el juego.',
    'warmup:2':
        'Adapta la rutina a tu tiempo y energía. No hace falta completar todos los ejercicios cada día. Si estás cansado, elige una sesión corta o descansa. Termina con una observación sobre lo que controlaste y algo que quieras notar la próxima vez.',
    'mindset:0':
        'Una racha de derrotas puede hacer que cada error parezca una prueba de que todo está mal. Antes de cambiar varias cosas, revisa un momento: dónde estaba tu atención, qué esperabas y qué probarías distinto. Las notas concretas ayudan; culparte no.',
    'mindset:1':
        'Las sesiones cortas ayudan a crear constancia y dejan espacio para recuperarte. Elige un objetivo sencillo, como detener la mira con precisión o mantener la mano relajada. Cuando lo consigas, puedes parar. Si pierdes el foco o te frustras, descansa.',
    'mindset:2':
        'En sesiones largas, cuida las manos y los ojos. Mira a lo lejos, parpadea, cambia de postura y relaja las manos. Para si sientes dolor, entumecimiento o tensión inusual. El historial registra la práctica, no tu valor. Volver descansado suele ser mejor que insistir cansado.'
  },
  'ar': {
    'sensitivity:0':
        'الحساسية تفضيل شخصي؛ اختر قيمة تساعدك على تحريك علامة التصويب وإيقافها في المكان المقصود. استخدم المولّد كمرجع تجريبي فقط، فقيمه محاكاة وليست توصية للعبة أو جهاز محدد.',
    'sensitivity:1':
        'غيّر قيمة واحدة في كل مرة. أجرِ تعديلًا بسيطًا وكرّر الحركة نفسها لبضع دقائق. لاحظ هل تتوقف قبل الهدف أم تتجاوزه أم تحافظ على التحكم. دوّن القيمة وشعورك بها لتتمكن من المقارنة لاحقًا.',
    'sensitivity:2':
        'لا تغيّر الحساسية بعد كل مباراة صعبة. فالتركيز والقبضة والراحة والظروف تؤثر في النتيجة. امنح الإعداد وقتًا للتعوّد. تغيير عدة عناصر معًا يصعّب معرفة ما أفادك؛ الراحة والثبات أهم من نسخ أرقام الآخرين.',
    'crosshair:0':
        'يبدأ التصويب الجيد قبل ظهور الهدف. أبقِ علامة التصويب قرب الارتفاع المتوقع للخصم لتقليل مسافة حركة يدك. أثناء التحرك، تخيّل المداخل المحتملة ووجّه نظرك بهدوء. يساعدك هذا الاستعداد على التفاعل بسرعة أكبر.',
    'crosshair:1':
        'استخدم إطارات الأبواب والحواف وتغيّر مستوى الأرض كعلامات للمحافظة على ارتفاع ثابت. عند الاقتراب من زاوية، وجّه التصويب قليلًا بعد الحافة وتقدّم بوتيرة تسمح بفحص كل فتحة. تحدد نقطة البداية مقدار التصحيح المطلوب.',
    'crosshair:2':
        'في تدريب التصويب السريع، أعد تركيزك إلى الوسط بين الأهداف. ابدأ الحركة من ارتفاع مناسب وتوقف بتحكم. راجع لاحقًا متى كان التصحيح الأول كبيرًا. التموضع الجيد لا يضمن الإصابة لكنه يسهّل القرار التالي.',
    'mechanics:0':
        'ينبغي أن يناسب تخطيط التحكم يديك وحجم الجهاز ومدى وصول مريحًا. يفضّل بعض اللاعبين الإبهامين، ويضيف آخرون أصابع لتقسيم المهام. لا يوجد تخطيط أفضل دائمًا؛ المهم أن تكرره دون شد الجهاز أو إجهاد اليد.',
    'mechanics:1':
        'عند تجربة أصابع إضافية، غيّر أمرًا واحدًا كل مرة في بيئة آمنة. أرخِ قبضتك وضع الأزرار حيث تستقر الأصابع طبيعيًا. إذا اصطدمت الأصابع أو تراجعت الدقة، بسّط التخطيط وحاول لاحقًا.',
    'mechanics:2':
        'استخدم تصحيحات صغيرة ومضبوطة واترك يدك ترتاح بين المحاولات. يساعد تدريب التصحيح الدقيق على هذه الحركات. اجعل الجلسات قصيرة وتوقف عند التيبّس أو الألم. تغيير الوضعية أثناء الاستراحة يجعل التدريب أريح.',
    'flick-tracking:0':
        'النقلة السريعة حركة قصيرة وحاسمة نحو هدف، وتفيد إذا ظهر لفترة وجيزة أو كان بعيدًا. أما التتبع فهو تعديل مستمر لمواكبة هدف متحرك. لكل منهما إيقاع مختلف، ولا تناسب تقنية واحدة كل الحالات.',
    'flick-tracking:1':
        'تدرّب على كل مهارة منفردة. في التصويب السريع، لاحظ هل تبدأ من الوسط وتتوقف عند الهدف. وفي التتبع، حافظ على سلاسة الحركة ولا تطارد كل تغير صغير. الهدف البقاء قريبًا، لا إجراء حركة واسعة.',
    'flick-tracking:2':
        'أثناء اللعب، راعِ المسافة والظهور والحركة. قد يتطلب الهدف العابر نقلة مضبوطة، بينما يسهل تتبع حركة ثابتة. يمكنك إعادة توجيه التصويب ثم متابعة الحركة. استخدم ملاحظاتك لاختيار هدف تدريبك القادم.',
    'recoil:0':
        'قد تبعد الطلقات المتكررة الرؤية عن نقطة البداية. غالبًا ما يسهل التحكم بتصحيح سلس ومدروس أكثر من سحب مفاجئ. يستخدم تدريب الارتداد هدفًا بسيطًا متحركًا للتدريب ولا يمثل سلاحًا أو لعبة بعينها.',
    'recoil:1':
        'تتيح الدفعات القصيرة فرصة للملاحظة وإعادة ضبط التصويب. أطلق مجموعة صغيرة ثم توقف وانظر إلى موضع التصويب. إذا ارتفع كثيرًا فصحح بلطف، وإذا سحبت للأسفل أكثر من اللازم فخفف الحركة. الملاحظة أنفع من حفظ أنماط غير مناسبة.',
    'recoil:2':
        'أرخِ يدك وحافظ على ثبات الرؤية. يعتمد التحكم على التوقيت والنمط الذي تلاحظه، وليس على السحب باتجاه واحد فقط. تدرّب بهدوء وتوقف قبل التعب. إعادة ضبط التصويب بين الدفعات تساعد على استعادة وضع مريح.',
    'scope:0':
        'يغيّر التقريب مجال الرؤية وتأثير حركات اليد الصغيرة. عند استخدام تقريب أكبر، ثبّت نظرك وحدد الهدف ثم صحح بحركة مقصودة. امنح عينيك لحظة للتأقلم قبل زيادة السرعة.',
    'scope:1':
        'قد يحتاج كل مستوى تقريب إلى حساسية مختلفة في لعبتك، لكن لا توجد معادلة عامة. قيم المولّد بيانات نموذجية محاكية. قارن مستوى واحدًا في كل مرة بالحركة نفسها وابحث عن تحكم ثابت لا عن السرعة فقط.',
    'scope:2':
        'قد يساعد التنفس الهادئ قبل الحركة الدقيقة. أرخِ كتفيك ولا تحبس أنفاسك طويلًا. قد يقلل الزفير الهادئ التوتر في يديك. إذا اهتزت الرؤية، عدّل وضعيتك وخفّف السرعة أو خذ استراحة.',
    'warmup:0':
        'يهيئ الإحماء تركيزك دون إنهاكك. جرّب عشر دقائق: دقيقتان للنقر على الهدف، ودقيقتان لرد الفعل، ودقيقتان للتصويب السريع، ودقيقتان للتتبع، ودقيقتان للحركة الأقل ثباتًا. اختر مستوى سهلًا.',
    'warmup:1':
        'خذ انتقالات قصيرة بين التدريبات. لاحظ قبضتك وتركيزك. إذا استعجلت، خفّف وتيرة المحاولة التالية. قائمة الصفحة الرئيسية تسجل تفضيلاتك فقط ولا تفحص الهاتف أو اللعبة ولا تضبطهما.',
    'warmup:2':
        'كيّف الروتين مع وقتك وطاقتك. لا تحتاج إلى كل التدريبات يوميًا. إذا كنت متعبًا فاختر جلسة أقصر أو استرح. اختم بملاحظة واحدة عمّا تحكمت به وما تريد الانتباه إليه في المرة القادمة.',
    'mindset:0':
        'قد تجعلك سلسلة الخسائر ترى كل خطأ دليلًا على أن إعدادك أو مهارتك سيئة. قبل تغيير أشياء كثيرة، راجع لحظة واحدة: أين كان تركيزك، وماذا توقعت، وما الذي ستجربه بشكل مختلف؟ الملاحظات المحددة مفيدة، واللوم لا يساعد.',
    'mindset:1':
        'تساعد الجلسات القصيرة على الثبات وتمنحك فرصة للتعافي. اختر هدفًا بسيطًا مثل إيقاف التصويب بدقة أو إبقاء يدك مرتاحة. عندما تحققه يمكنك التوقف. إذا ضعف تركيزك أو شعرت بالإحباط فخذ استراحة.',
    'mindset:2':
        'في الجلسات الطويلة، اعتنِ بيديك وعينيك. انظر بعيدًا عن الشاشة وارمش وغيّر وضعيتك وأرخِ يديك. توقف إذا شعرت بألم أو خدر أو إجهاد غير معتاد. السجل يوثق التدريب ولا يحكم عليك؛ العودة بعد الراحة أفضل من الاستمرار مع التعب.'
  }
};
