import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_durations.dart';
import '../../../core/error/failure_messages.dart';
import '../../../core/theme/app_colors.dart';
import 'home_cubit.dart';
import 'home_state.dart';
import 'widgets/home_content.dart';
import 'widgets/home_error_view.dart';
import 'widgets/home_skeleton.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Scaffold(
      backgroundColor: colors.bg,
      body: SafeArea(
        bottom: false,
        child: BlocListener<HomeCubit, HomeState>(
          listenWhen: (previous, current) =>
              previous.isRefreshing &&
              !current.isRefreshing &&
              current.status == HomeStatus.ready &&
              current.failure != null,
          listener: (context, state) {
            final failure = state.failure;
            if (failure == null) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(context.tr(failureMessageKey(failure)))),
            );
          },
          child: BlocBuilder<HomeCubit, HomeState>(
            buildWhen: (previous, current) => previous.status != current.status,
            builder: (context, state) => AnimatedSwitcher(
              duration: AppDurations.pageFade,
              child: switch (state.status) {
                HomeStatus.loading => const HomeSkeleton(),
                HomeStatus.failure => const HomeErrorView(),
                HomeStatus.ready => const HomeContent(),
              },
            ),
          ),
        ),
      ),
    );
  }
}
