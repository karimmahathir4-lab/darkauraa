class Lesson {
  const Lesson(
      {required this.id,
      required this.module,
      required this.title,
      required this.minutes,
      required this.drillId,
      required this.paragraphs,
      required this.takeaways});
  final String id;
  final String module;
  final String title;
  final int minutes;
  final String drillId;
  final List<String> paragraphs;
  final List<String> takeaways;
}

const List<Lesson> lessons = <Lesson>[
  Lesson(
      id: 'sensitivity',
      module: 'Foundations',
      title: 'Finding Your Sensitivity',
      minutes: 3,
      drillId: 'tap_target',
      paragraphs: <String>[
        'Sensitivity is a personal control setting: the useful value is the one that lets you make a deliberate movement and stop where you intended. A setting that feels quick in one moment may feel unstable when you are tired, so judge it across several short practice attempts. Begin by choosing a comfortable baseline in your own game. Use the sample generator in Device Infos only as a discussion prompt; its values are simulated and are not recommendations for a particular game or device.',
        'Test one change at a time. Make a small adjustment, then repeat the same movement or target exercise for a few minutes. Notice whether you consistently stop short, pass the target, or feel controlled. If the result is unclear, return to your baseline rather than stacking more changes. Keeping a short note of the value and what you felt makes comparisons much more useful than relying on memory.',
        'Avoid changing sensitivity after every difficult match. Results vary with attention, grip, sleep, and the specific situation. Give a setting enough practice sessions to become familiar before deciding it is unsuitable. If you change several controls together, you will not know which one helped. Comfort matters more than copying another player’s number, and a stable setup makes improvement easier to measure.'
      ],
      takeaways: <String>[
        'Start from a comfortable baseline.',
        'Change one value by a small amount.',
        'Compare across several calm practice sessions.'
      ]),
  Lesson(
      id: 'crosshair',
      module: 'Foundations',
      title: 'Crosshair Placement',
      minutes: 3,
      drillId: 'flick',
      paragraphs: <String>[
        'Good aim often begins before a target appears. Keeping your crosshair near the height where an opponent could appear reduces the distance your hand must travel. As you move through a space, imagine likely openings and guide your view toward them. This is pre-aim: a quiet preparation that gives you more time to react without requiring a dramatic last-second flick.',
        'Use landmarks to keep your aim steady. Door frames, wall edges, and changes in floor height can help you estimate a consistent level. When approaching a corner, place the crosshair just beyond the edge you expect to clear, then move your view at a pace that lets you inspect each opening. Avoid staring at the floor while traveling unless the immediate situation requires it; your starting position determines how much correction you need later.',
        'Practice with the Flick Shots drill by returning your attention to the center between targets. Focus on beginning each movement from a useful height and stopping cleanly. In a game, review moments where your first correction was large. Ask whether the crosshair could have been better positioned before contact. Better placement does not guarantee a hit, but it makes the next decision simpler and can reduce rushed movement.'
      ],
      takeaways: <String>[
        'Keep the crosshair near likely target height.',
        'Pre-aim common openings while moving.',
        'Review the starting position before blaming speed.'
      ]),
  Lesson(
      id: 'mechanics',
      module: 'Control',
      title: 'Thumb and Finger Mechanics',
      minutes: 4,
      drillId: 'micro_adjust',
      paragraphs: <String>[
        'Your control layout should fit your hands, device size, and comfortable reach. Many players use their thumbs for movement and aiming because the posture feels familiar. Others place extra fingers on additional controls to reduce how often a thumb must leave its task. Neither arrangement is automatically better. A layout only helps when you can use it repeatedly without squeezing the device or reaching awkwardly.',
        'If you explore a multi-finger layout, add one change at a time in a safe practice environment. Keep the grip relaxed and make sure each finger can press its intended area without shifting the whole device. Button placement should support a natural resting position. If your fingers collide, your grip becomes tense, or you lose precision, simplify the arrangement and try again later. Progress is not measured by how many fingers are involved.',
        'Use small controlled movements for corrections and allow the hand to reset between repetitions. The Micro-Adjust drill encourages these quiet movements. Keep sessions short, pause when you feel stiffness, and avoid forcing a position through discomfort. Stretching gently and changing posture during breaks can make practice more sustainable. Persistent pain is a signal to stop and seek appropriate advice, not a challenge to push through.'
      ],
      takeaways: <String>[
        'Choose a layout that fits your reach.',
        'Add control changes gradually.',
        'Relax your grip and stop when discomfort appears.'
      ]),
  Lesson(
      id: 'flick-tracking',
      module: 'Control',
      title: 'Flick vs Tracking',
      minutes: 3,
      drillId: 'tracking',
      paragraphs: <String>[
        'A flick is a short, decisive movement toward a target. It can help when the target is briefly visible or far from your current aim point. Tracking is a continuous adjustment that keeps your view aligned with something moving. Both rely on reading direction and controlling your stopping point, but they ask for different rhythms. A quick flick is not a substitute for steady follow-through, and constant tracking is not always efficient when a target changes direction sharply.',
        'Practice each skill separately before mixing them. In Flick Shots, notice whether you begin from a balanced center and whether your movement stops on the target. In Tracking, keep the motion smooth and avoid chasing every tiny change. Let your hand follow the broader path. If the target moves unpredictably, use small corrections rather than one tense sweep. The goal is to stay close, not to make the most dramatic movement.',
        'During a match, decide from the target’s distance, visibility, and motion. A target crossing quickly may invite one controlled flick; a target moving steadily may be easier to follow. You can combine the ideas: reposition once, then track the remaining motion. After practice, recall where you over-corrected or fell behind. That observation gives your next session a useful focus without requiring a long routine.'
      ],
      takeaways: <String>[
        'Flick for a brief reposition; track sustained movement.',
        'Practice each rhythm on its own.',
        'Use small corrections to recover control.'
      ]),
  Lesson(
      id: 'recoil',
      module: 'Control',
      title: 'Recoil and Burst Control',
      minutes: 3,
      drillId: 'recoil_control',
      paragraphs: <String>[
        'Repeated shots can move a view away from its starting point. A smooth, measured counter-movement is easier to control than a sudden pull. The Recoil Control drill uses a simple drifting target to practice this idea without representing any particular weapon or game. Pay attention to whether your correction is gradual and whether your crosshair stays near the target rather than swinging far past it.',
        'Short bursts can give you a moment to observe and reset your aim. Try a small group of shots, pause briefly, and check where the crosshair settled. If it climbed too far, adjust your next movement gently. If you pulled down too strongly, reduce the correction. These observations are more useful than memorizing a pattern from a different device or game, because controls and mechanics can vary.',
        'When practicing, keep your hand loose and your view steady. Recoil management is not simply pulling in one direction; the amount of correction depends on timing and the pattern you observe. Use controlled repetitions, then stop before fatigue makes your movements careless. In play, choose a burst length that lets you stay aware of the target and the surroundings. Resetting aim between bursts can restore a comfortable starting point.'
      ],
      takeaways: <String>[
        'Use gradual counter-movements.',
        'Pause to observe and reset between bursts.',
        'Practice what you see rather than memorizing unrelated patterns.'
      ]),
  Lesson(
      id: 'scope',
      module: 'Awareness',
      title: 'Scope Handling',
      minutes: 3,
      drillId: 'tap_target',
      paragraphs: <String>[
        'A zoomed view changes how much of the scene you can see and how large a small hand movement appears. Use a little patience when entering a higher zoom level: settle your view, identify the target, and make a deliberate correction. Switching between zoom levels can feel unfamiliar because the visual scale changes. Give your eyes a moment to readjust instead of immediately making several fast movements.',
        'Different zoom levels may benefit from separate sensitivity choices in the game you use, but there is no universal formula. The simulated values shown in Device Infos are sample data only. If you tune your own setup, compare one zoom level at a time with the same simple movement. Look for control and repeatability, not just raw speed. A small, stable adjustment is easier to evaluate than a large change made during a stressful match.',
        'Breathing can help you pause before a precise action. Let your shoulders soften and avoid holding your breath for a long stretch. A calm exhale can reduce unnecessary tension in your hands. This is not a special trick that guarantees accuracy; it is a simple way to notice when you are rushing. If your view feels shaky, reset your posture, lower the pace, and take a brief break when needed.'
      ],
      takeaways: <String>[
        'Give your view time to settle after zoom changes.',
        'Tune each zoom level separately in your own game.',
        'Use a relaxed pause before precise corrections.'
      ]),
  Lesson(
      id: 'warmup',
      module: 'Practice',
      title: 'Warm-up Routine',
      minutes: 3,
      drillId: 'reaction',
      paragraphs: <String>[
        'A warm-up should prepare your attention, not exhaust it. Here is a simple ten-minute outline you can adapt: spend two minutes on calm Tap Target repetitions, two minutes waiting for the cue in Reaction Test, two minutes on controlled Flick Shots, and two minutes following a moving target. Use the final two minutes to repeat whichever movement felt least settled. Keep the difficulty comfortable so you can focus on clean actions.',
        'Take short transitions between drills. Notice how your grip feels and whether your attention is steady. If you are rushing, slow the next repetition rather than adding more speed. A warm-up is also a chance to check that your personal layout feels familiar. The checklist on Home is only a reminder for your own preferences; it does not inspect or configure your phone or game.',
        'Adapt this routine to your schedule and energy. You do not need to complete every drill each day. On a tired day, choose a shorter session or rest. Consistent practice comes from manageable repetitions over time, not from forcing a long session. Finish with one sentence about what felt controlled and one thing you want to notice next time. That small review connects warm-up practice with purposeful improvement.'
      ],
      takeaways: <String>[
        'Keep the warm-up short and comfortable.',
        'Use a variety of easy drills.',
        'End with one observation for next time.'
      ]),
  Lesson(
      id: 'mindset',
      module: 'Practice',
      title: 'Mindset and Consistency',
      minutes: 4,
      drillId: 'target_switch',
      paragraphs: <String>[
        'A losing streak can make every mistake feel like proof that your setup or skill is broken. Pause before changing several things at once. A difficult match may reflect decisions, timing, teammates, or simple variation. Choose one moment to review: where was your attention, what did you expect, and what could you try differently next time? Keep the review curious rather than harsh. Specific notes create useful experiments; insults do not.',
        'Short sessions can build consistency while leaving room for recovery. Pick a small goal such as stopping cleanly on a target or staying relaxed through a set. When that goal is complete, you can stop even if you have not practiced for long. Rest helps attention recover. If focus fades or frustration rises, take a break rather than trying to force better performance from a tired hand.',
        'For long sessions, take a break for hand and eye health. Look away from the screen, blink, change posture, and gently loosen your hands. Stop if you feel pain, numbness, or unusual strain. Progress is rarely a straight line, so use your saved drill history as a record of practice rather than a judgment of your worth. Returning calmly tomorrow is often more valuable than squeezing in one more tired attempt.'
      ],
      takeaways: <String>[
        'Review one specific moment without self-blame.',
        'Use a small goal and a manageable session.',
        'Take breaks and rest when focus or comfort drops.'
      ]),
];
