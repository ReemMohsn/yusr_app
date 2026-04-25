import 'package:flutter/material.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/extensions/context_extension.dart';

class NotesCard extends StatelessWidget {
  const NotesCard({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;
    final List<String> notes = [
      locale.note1,
      locale.note2,
      locale.note3,
      locale.note4,
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColor.withe,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.inputFieldBoundaries, width: 0.7),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withValues(alpha: 0.10),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
          BoxShadow(
            color: AppColor.black.withValues(alpha: 0.06),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Header ──
          Row(
            children: [
              const Icon(Icons.shield_outlined, color: AppColor.golden, size: 20),
              const SizedBox(width: 8),
              Text(
                locale.importantNotesTitle,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: AppColor.baseFontColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // ── Note rows ──
          ...List.generate(notes.length, (i) {
            return Padding(
              padding: EdgeInsets.only(bottom: i < notes.length - 1 ? 12 : 0),
              child: _NoteRow(number: i + 1, text: notes[i]),
            );
          }),
        ],
      ),
    );
  }
}

class _NoteRow extends StatelessWidget {
  final int number;
  final String text;

  const _NoteRow({required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // ── Number circle ──
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColor.golden.withValues(alpha: 0.20),
                AppColor.highlightBackground2,
              ],
            ),
          ),
          child: Center(
            child: Text(
              number.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: AppColor.baseFontColor,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // ── Note text ──
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              color: AppColor.textGrey,
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }
}
