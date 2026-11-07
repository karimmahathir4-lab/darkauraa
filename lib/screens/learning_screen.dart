import 'package:flutter/material.dart';

import '../app_state.dart';
import '../data/lessons.dart';
import '../drills/drill_base.dart';
import '../theme.dart';
import '../localization.dart';
import 'training_screen.dart';
import 'widgets.dart';

class LearningScreen extends StatelessWidget {
  const LearningScreen({required this.state, super.key});
  final AppState state;

  @override
  Widget build(BuildContext context) {
    final progress = state.completedLessons.length / lessons.length;
    final modules = lessons.map((lesson) => lesson.module).toSet();
    return ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: <Widget>[
          AuraCard(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                Row(children: <Widget>[
                  Expanded(
                      child: Text(context.tr('Learning Progress'),
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  Text('${(progress * 100).round()}%',
                      style: const TextStyle(
                          color: AuraColors.red, fontWeight: FontWeight.bold)),
                ]),
                const SizedBox(height: 12),
                ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                        color: AuraColors.red,
                        backgroundColor: const Color(0xFF303030))),
                const SizedBox(height: 8),
                Text(
                    '${state.completedLessons.length} ${context.tr('of')} ${lessons.length} ${context.tr('lessons complete')}',
                    style: const TextStyle(
                        color: AuraColors.secondary, fontSize: 11)),
              ])),
          for (final module in modules) ...<Widget>[
            Padding(
                padding: const EdgeInsets.fromLTRB(4, 20, 4, 10),
                child: Text(context.tr(module).toUpperCase(),
                    style: const TextStyle(
                        color: AuraColors.secondary,
                        fontSize: 11,
                        letterSpacing: 1.4,
                        fontWeight: FontWeight.bold))),
            for (final lesson
                in lessons.where((item) => item.module == module)) ...<Widget>[
              _lessonTile(context, lesson),
              const SizedBox(height: 10),
            ],
          ],
          Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                  context.tr(
                      'Take a break during long sessions. Look away from the screen and relax your hands and eyes.'),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AuraColors.secondary, fontSize: 12))),
        ]);
  }

  Widget _lessonTile(BuildContext context, Lesson lesson) {
    final done = state.completedLessons.contains(lesson.id);
    return AuraCard(
        child: InkWell(
      onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(
          builder: (_) => LessonPage(state: state, lesson: lesson))),
      child: Row(children: <Widget>[
        SizedBox.square(
            dimension: 43,
            child: Stack(alignment: Alignment.center, children: <Widget>[
              CircularProgressIndicator(
                  value: done ? 1 : 0,
                  strokeWidth: 3,
                  color: AuraColors.red,
                  backgroundColor: const Color(0xFF303030)),
              Icon(done ? Icons.check : Icons.menu_book,
                  color: done ? AuraColors.red : AuraColors.secondary,
                  size: 18),
            ])),
        const SizedBox(width: 12),
        Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
              Text(context.tr(lesson.title),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 4),
              Text(
                  '${lesson.minutes} ${context.tr('min read')}${done ? '  •  ${context.tr('Complete')}' : ''}',
                  style: const TextStyle(
                      color: AuraColors.secondary, fontSize: 11)),
            ])),
        const Icon(Icons.chevron_right, color: AuraColors.secondary),
      ]),
    ));
  }
}

class LessonPage extends StatefulWidget {
  const LessonPage({required this.state, required this.lesson, super.key});
  final AppState state;
  final Lesson lesson;
  @override
  State<LessonPage> createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    final lesson = widget.lesson;
    final completed = widget.state.completedLessons.contains(lesson.id);
    final drill =
        trainingDrills.firstWhere((item) => item.id == lesson.drillId);
    return Scaffold(
      appBar: AppBar(title: Text(context.tr(lesson.module))),
      body: ListView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
          children: <Widget>[
            Text(context.tr(lesson.title),
                style: const TextStyle(
                    fontSize: 26, height: 1.15, fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            Text('${lesson.minutes} ${context.tr('minute read')}',
                style:
                    const TextStyle(color: AuraColors.secondary, fontSize: 12)),
            const SizedBox(height: 20),
            for (var index = 0;
                index < lesson.paragraphs.length;
                index++) ...<Widget>[
              Text(
                  context.lessonParagraph(
                      lesson.id, index, lesson.paragraphs[index]),
                  style: const TextStyle(
                      fontSize: 14, height: 1.65, color: Color(0xFFE3E3E3))),
              const SizedBox(height: 16),
            ],
            AuraCard(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                  Text(context.tr('Key takeaways'),
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: AuraColors.red)),
                  const SizedBox(height: 10),
                  for (final takeaway in lesson.takeaways)
                    Padding(
                        padding: const EdgeInsets.only(bottom: 7),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Icon(Icons.check,
                                  color: AuraColors.red, size: 17),
                              const SizedBox(width: 8),
                              Expanded(
                                  child: Text(context.tr(takeaway),
                                      style: const TextStyle(
                                          fontSize: 13, height: 1.3))),
                            ])),
                ])),
            const SizedBox(height: 14),
            OutlinedButton.icon(
              onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                      builder: (_) => DrillSessionScreen(
                          drill: drill,
                          difficulty: 'Medium',
                          durationSeconds: 30,
                          state: widget.state))),
              icon: const Icon(Icons.sports_esports),
              label: Text(
                  '${context.tr('Try this drill')}: ${context.tr(drill.name)}'),
            ),
            const SizedBox(height: 8),
            SizedBox(
                height: 48,
                child: FilledButton(
                  onPressed: _busy
                      ? null
                      : () async {
                          setState(() => _busy = true);
                          await widget.state
                              .setLessonComplete(lesson.id, !completed);
                          if (!mounted) return;
                          setState(() => _busy = false);
                        },
                  child: Text(_busy
                      ? 'SAVING...'
                      : completed
                          ? 'MARK AS INCOMPLETE'
                          : 'MARK AS COMPLETE'),
                )),
          ]),
    );
  }
}
