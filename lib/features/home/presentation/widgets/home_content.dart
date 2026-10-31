import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../home_cubit.dart';
import '../home_intent.dart';
import 'budget_ruler_card.dart';
import 'home_header.dart';
import 'home_kpis.dart';
import 'home_quick_actions.dart';
import 'pace_note_card.dart';
import 'pending_review_card.dart';
import 'recent_expenses_section.dart';
import 'remaining_hero.dart';
import 'savings_section.dart';
import 'upcoming_obligations_section.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  Future<void> _refresh(BuildContext context) async {
    final cubit = context.read<HomeCubit>()..doEvent(const HomeRefreshed());
    await cubit.stream.firstWhere((state) => !state.isRefreshing);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return RefreshIndicator(
      color: colors.acc,
      backgroundColor: colors.surface,
      onRefresh: () => _refresh(context),
      child: const CustomScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: HomeHeader()),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              AppDimensions.pageGutter,
              AppDimensions.sm,
              AppDimensions.pageGutter,
              AppDimensions.xl,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate.fixed([
                PendingReviewCard(),
                RemainingHero(),
                HomeKpis(),
                BudgetRulerCard(),
                PaceNoteCard(),
                HomeQuickActions(),
                SavingsSection(),
                UpcomingObligationsSection(),
                RecentExpensesSection(),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
