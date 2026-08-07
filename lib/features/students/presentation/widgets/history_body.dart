import 'package:bitacoras_app/features/students/attendance.dart';
import 'package:flutter/material.dart';
import 'package:bitacoras_app/shared/exports.dart';
import '../../domain/models/practice_record_model.dart';
import 'history_empty_state.dart';
import 'history_header.dart';

class HistoryBody extends StatelessWidget {
  final PracticeRecordModel? activeRecord;
  final List<PracticeRecordModel> historyList;
  final VoidCallback? onRegisterExit;

  const HistoryBody({
    super.key,
    required this.activeRecord,
    required this.historyList,
    this.onRegisterExit,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(AppSizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HistoryHeader(),
          AppSizes.gapV24,

          if (activeRecord != null) ...[
            ActiveSessionCard(
              record: activeRecord!,
              onExitPressed: onRegisterExit ?? () {},
            ),
            AppSizes.gapV16,
          ],

          Text(
            'REGISTROS ANTERIORES',
            style: AppTextStyles.caption.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
              color: AppColors.textSecondary,
            ),
          ),
          AppSizes.gapV8,

          if (historyList.isEmpty)
            const HistoryEmptyState()
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: historyList.length,
              separatorBuilder: (context, index) => AppSizes.gapV16,
              itemBuilder: (context, index) {
                return HistoryCard(
                  record: historyList[index],
                  onDetailPressed: () {
                    // Navegar al detalle de bitácora
                  },
                );
              },
            ),
        ],
      ),
    );
  }
}