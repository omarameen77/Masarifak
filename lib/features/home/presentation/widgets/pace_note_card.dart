import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/widgets/app_note.dart';
import '../../domain/entities/pace_note.dart';
import '../home_cubit.dart';
import '../home_presentation.dart';
import '../home_state.dart';

class PaceNoteCard extends StatelessWidget {
  const PaceNoteCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<HomeCubit, HomeState, PaceNote?>(
      selector: (state) => state.summary?.paceNote,
      builder: (context, note) {
        if (note == null) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.only(top: AppDimensions.md),
          child: AppNote(
            kind: note.tone.noteKind,
            icon: note.tone.icon,
            child: Text(note.text),
          ),
        );
      },
    );
  }
}
